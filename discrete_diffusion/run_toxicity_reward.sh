#!/bin/bash

# BoN 4 particles
python generate_with_fk.py \
	seed=1234 \
	eval.checkpoint_path=kuleshov-group/mdlm-owt \
		data=openwebtext-split  \
		model.length=128  \
		sampling.predictor=ddpm  \
		sampling.steps=1000 \
			loader.eval_batch_size=1 \
			sampling.num_sample_batches=20 \
			backbone=hf_dit \
		fk_steering.potential_type='bon' \
		fk_steering.k_particles=4 \
		fk_steering.lmbda=10.0 \
		fk_steering.reward_trim_length=100 \
		fk_steering.reward_fn='toxicity' \
		fk_steering.reward_label='positive' \
		fk_steering.resample_frequency=-1 \
		fk_steering.num_x0_samples=4 \
		fk_steering.resample_start_step=-1 \
		sampling.prompt_file=$(pwd)/evaluation/pplm_discrim_prompts_orig.jsonl

# FK 4 particles
python generate_with_fk.py \
	seed=1234 \
	eval.checkpoint_path=kuleshov-group/mdlm-owt \
		data=openwebtext-split  \
		model.length=128  \
		sampling.predictor=ddpm  \
		sampling.steps=1000 \
			loader.eval_batch_size=1 \
			sampling.num_sample_batches=20 \
			backbone=hf_dit \
		fk_steering.potential_type='diff' \
		fk_steering.k_particles=4 \
		fk_steering.lmbda=10.0 \
		fk_steering.reward_trim_length=100 \
		fk_steering.reward_fn='toxicity' \
		fk_steering.reward_label='positive' \
		fk_steering.resample_frequency=20 \
		fk_steering.num_x0_samples=4 \
		fk_steering.resample_start_step=-1 \
		sampling.prompt_file=$(pwd)/evaluation/pplm_discrim_prompts_orig.jsonl

# BoN 8 particles
python generate_with_fk.py \
	seed=1234 \
	eval.checkpoint_path=kuleshov-group/mdlm-owt \
		data=openwebtext-split  \
		model.length=128  \
		sampling.predictor=ddpm  \
		sampling.steps=1000 \
			loader.eval_batch_size=1 \
			sampling.num_sample_batches=20 \
			backbone=hf_dit \
		fk_steering.potential_type='bon' \
		fk_steering.k_particles=8 \
		fk_steering.lmbda=10.0 \
		fk_steering.reward_trim_length=100 \
		fk_steering.reward_fn='toxicity' \
		fk_steering.reward_label='positive' \
		fk_steering.resample_frequency=-1 \
		fk_steering.num_x0_samples=4 \
		fk_steering.resample_start_step=-1 \
		sampling.prompt_file=$(pwd)/evaluation/pplm_discrim_prompts_orig.jsonl

# FK 8 particles
python generate_with_fk.py \
	seed=1234 \
	eval.checkpoint_path=kuleshov-group/mdlm-owt \
		data=openwebtext-split  \
		model.length=128  \
		sampling.predictor=ddpm  \
		sampling.steps=1000 \
			loader.eval_batch_size=1 \
			sampling.num_sample_batches=20 \
			backbone=hf_dit \
		fk_steering.potential_type='diff' \
		fk_steering.k_particles=8 \
		fk_steering.lmbda=10.0 \
		fk_steering.reward_trim_length=100 \
		fk_steering.reward_fn='toxicity' \
		fk_steering.reward_label='positive' \
		fk_steering.resample_frequency=20 \
		fk_steering.num_x0_samples=4 \
		fk_steering.resample_start_step=-1 \
		sampling.prompt_file=$(pwd)/evaluation/pplm_discrim_prompts_orig.jsonl


# FK 4 particles, 16 x0 samples
python generate_with_fk.py \
	seed=1234 \
	eval.checkpoint_path=kuleshov-group/mdlm-owt \
		data=openwebtext-split  \
		model.length=128  \
		sampling.predictor=ddpm  \
		sampling.steps=1000 \
			loader.eval_batch_size=1 \
			sampling.num_sample_batches=20 \
			backbone=hf_dit \
		fk_steering.potential_type='diff' \
		fk_steering.k_particles=4 \
		fk_steering.lmbda=10.0 \
		fk_steering.reward_trim_length=100 \
		fk_steering.reward_fn='toxicity' \
		fk_steering.reward_label='positive' \
		fk_steering.resample_frequency=20 \
		fk_steering.num_x0_samples=16 \
		fk_steering.resample_start_step=-1 \
		sampling.prompt_file=$(pwd)/evaluation/pplm_discrim_prompts_orig.jsonl


# FK 8 particles, 16 x0 samples
python generate_with_fk.py \
	seed=1234 \
	eval.checkpoint_path=kuleshov-group/mdlm-owt \
		data=openwebtext-split  \
		model.length=128  \
		sampling.predictor=ddpm  \
		sampling.steps=1000 \
			loader.eval_batch_size=1 \
			sampling.num_sample_batches=20 \
			backbone=hf_dit \
		fk_steering.potential_type='diff' \
		fk_steering.k_particles=8 \
		fk_steering.lmbda=10.0 \
		fk_steering.reward_trim_length=100 \
		fk_steering.reward_fn='toxicity' \
		fk_steering.reward_label='positive' \
		fk_steering.resample_frequency=20 \
		fk_steering.num_x0_samples=16 \
		fk_steering.resample_start_step=-1 \
		sampling.prompt_file=$(pwd)/evaluation/pplm_discrim_prompts_orig.jsonl