git clone git@github.com:namezhenzhang/tau2-bench-local-host-reasoning-model.git
cd tau2-bench

conda create -n tau2 python=3.10 -y && conda activate tau2

pip install -e .

tau2 check-data

cp .env.example .env

# set api in .env