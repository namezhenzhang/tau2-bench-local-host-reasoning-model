# docker
docker run -it --name zhenzhang_sglang --gpus all \
    --shm-size 16g \
    -p 10001:10001 \
    -v /data2/zzhang/.cache/huggingface:/root/.cache/huggingface \
    -v /data2/zzhang/dir1/:/workspace \
    --env "HF_TOKEN=<your huggingface token>" \
    --ipc=host \
    --network host \
    lmsysorg/sglang:latest \
    /bin/bash

# start the docker at the second time
docker start -i zhenzhang_sglang

# host the model
cd /workspace/Checklist-Agent-RL/models/

export MODEL_DIR=namezz/drgrpo-tis-fix2-newdata-cold-start-qwen3-8b-n48-1111-step-950-hf
CUDA_VISIBLE_DEVICES=0,1,2,3 python3 -m sglang.launch_server \
    --model-path ${MODEL_DIR} \
    --tp-size 4 \
    --dp-size 1 \
    --context-length 40960 \
    --host 0.0.0.0 \
    --mem-fraction-static 0.90 \
    --port 1053 \
    --tool-call-parser qwen \
    --chat-template ./chat_template_add_think_merge_system.jinja \
    --reasoning-parser deepseek-r1 \
    --enable-deterministic-inference \
    --log-requests \
    --log-requests-level 3


# run the tau2-bench
export OPENAI_API_KEY=<your openai api key>
tau2 run \
--domain retail \
--agent-llm openai/drgrpo-tis-fix2-newdata-cold-start-qwen3-8b-n48-1111-step-950-hf \
--user-llm gpt-4.1 \
--num-trials 1 \
--max-concurrency 200 \
--save-to drgrpo-n48-step-950_retail \
--user-llm-args  '{"api_base":"https://api.openai.com/v1"}' \
--agent-llm-args '{"temperature": 0.0, "top_p": 0.95, "api_base":"http://127.0.0.1:1053/v1"}' 