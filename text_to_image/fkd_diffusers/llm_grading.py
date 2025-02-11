from google import genai
from google.genai import types
import typing_extensions as typing
from PIL import Image
import io
import os


class Score(typing.TypedDict):
    score: float
    explanation: str


class Grading(typing.TypedDict):
    accuracy_to_prompt: Score
    creativity_and_originality: Score
    visual_quality_and_realism: Score
    consistency_and_cohesion: Score
    emotional_or_thematic_resonance: Score
    overall_score: Score

def convert_to_bytes(image: Image.Image) -> bytes:
    """Load an image from a path or URL and convert it to bytes."""
    image = image.convert("RGB")
    image_bytes_io = io.BytesIO()
    image.save(image_bytes_io, format="PNG")
    return image_bytes_io.getvalue()


def prepare_inputs(prompt: str, image: Image.Image):
    """Prepare inputs for the API from a given prompt and image."""
    inputs = [
        types.Part.from_text(text=prompt),
        types.Part.from_bytes(data=convert_to_bytes(image), 
mime_type="image/png"),
    ]
    return inputs

def load_gemini_client():
    client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
    system_instruction = VERIFIER_PROMPT.replace('"""', "")
    generation_config = types.GenerateContentConfig(
        system_instruction=system_instruction,
        response_mime_type="application/json",
        response_schema=list[Grading],
        seed=1994,
    )
    return client, generation_config


class LLMGrader:
    def __init__(self):
        client, gen_config = load_gemini_client()
        self.client = client 
        self.generation_config = gen_config
        self.supported_metrics = [
            "accuracy_to_prompt", 
            "creativity_and_originality", 
            "visual_quality_and_realism", 
            "consistency_and_cohesion", 
            "emotional_or_thematic_resonance", 
            "overall_score"
        ]

    def score(self, images, prompts, metric_to_chase="overall_score", 
max_new_tokens=300):
        if metric_to_chase not in self.supported_metrics:
            raise ValueError(f"Unknown `{metric_to_chase=}` obtained. 
Supported ones are: {self.supported_metrics}")
        
        images = [images] if not isinstance(images, list) else images
        prompts = [prompts] if not isinstance(prompts, list) else prompts

        inputs = []
        for text, image in zip(prompts, images):
            inputs.extend(prepare_inputs(prompt=text, image=image))
        
        response = self.client.models.generate_content(
            model="gemini-2.0-flash", 
            contents=types.Content(parts=inputs, role="user"), 
            config=self.generation_config
        )
        return response.parsed[0][metric_to_chase]["score"]


# Comes from https://arxiv.org/abs/2501.09732
VERIFIER_PROMPT = """
You are a multimodal large-language model tasked with evaluating images
generated by a text-to-image model. Your goal is to assess each generated
image based on specific aspects and provide a detailed critique, along with
a scoring system. The final output should be formatted as a JSON object
containing individual scores for each aspect and an overall score. The keys
in the JSON object should be: `accuracy_to_prompt`, 
`creativity_and_originality`,
`visual_quality_and_realism`, `consistency_and_cohesion`,
`emotional_or_thematic_resonance`, and `overall_score`. Below is a 
comprehensive
guide to follow in your evaluation process:

1. Key Evaluation Aspects and Scoring Criteria:
For each aspect, provide a score from 0 to 10, where 0 represents poor
performance and 10 represents excellent performance. For each score, 
include
a short explanation or justification (1-2 sentences) explaining why that
score was given. The aspects to evaluate are as follows:

a) Accuracy to Prompt
Assess how well the image matches the description given in the prompt.
Consider whether all requested elements are present and if the scene,
objects, and setting align accurately with the text. Score: 0 (no
alignment) to 10 (perfect match to prompt).

b) Creativity and Originality
Evaluate the uniqueness and creativity of the generated image. Does the
model present an imaginative or aesthetically engaging interpretation of 
the
prompt? Is there any evidence of creativity beyond a literal 
interpretation?
Score: 0 (lacks creativity) to 10 (highly creative and original).

c) Visual Quality and Realism
Assess the overall visual quality, including resolution, detail, and 
realism.
Look for coherence in lighting, shading, and perspective. Even if the image
is stylized or abstract, judge whether the visual elements are 
well-rendered
and visually appealing. Score: 0 (poor quality) to 10 (high-quality and
realistic).

d) Consistency and Cohesion
Check for internal consistency within the image. Are all elements cohesive
and aligned with the prompt? For instance, does the perspective make sense,
and do objects fit naturally within the scene without visual anomalies?
Score: 0 (inconsistent) to 10 (fully cohesive and consistent).

e) Emotional or Thematic Resonance
Evaluate how well the image evokes the intended emotional or thematic tone 
of
the prompt. For example, if the prompt is meant to be serene, does the 
image
convey calmness? If it’s adventurous, does it evoke excitement? Score: 0
(no resonance) to 10 (strong resonance with the prompt’s theme).

2. Overall Score
After scoring each aspect individually, provide an overall score,
representing the model’s general performance on this image. This should be
a weighted average based on the importance of each aspect to the prompt or 
an
average of all aspects.
"""
