#!/bin/bash

# Function to check the exit status of the last command and exit if it failed
check_exit_status() {
    if [ $? -ne 0 ]; then
        echo "Error occurred in the previous step. Exiting."
        exit 1
    fi
}

# Install dependencies
conda create -n ai_scientist python=3.11 -y
conda activate ai_scientist
check_exit_status

pip install anthropic aider-chat backoff openai matplotlib pypdf pymupdf4llm torch numpy transformers datasets tiktoken wandb tqdm
check_exit_status

sudo apt-get install texlive-full -y
check_exit_status

# Prepare NanoGPT data
python data/enwik8/prepare.py
check_exit_status

python data/shakespeare_char/prepare.py
check_exit_status

python data/text8/prepare.py
check_exit_status

# Generate ideas
python3 ai_scientist/generate_ideas.py --experiment "$1" --model "$2" --num-ideas "$3"
check_exit_status

# Perform experiments
python3 ai_scientist/perform_experiments.py --experiment "$1" --model "$2"
check_exit_status

# Perform writeup
python3 ai_scientist/perform_writeup.py --experiment "$1" --model "$2"
check_exit_status

# Perform review
python3 ai_scientist/perform_review.py --experiment "$1" --model "$2"
check_exit_status
