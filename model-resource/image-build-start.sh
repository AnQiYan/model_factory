#!/usr/bin/env bash
CUR_DIR=$(readlink -e $(dirname "$0"))
export CUR_DIR

echo "root" > "/etc/arg_mamba_user"
export MAMBA_USER=root
export USER="root"
export HOME="/root"

cat <<< $(readlink -e ~)

cat > /usr/local/bin/_entrypoint.sh <<-EOF
#!/usr/bin/env bash
set -ef -o pipefail

export USER=$USER
export HOME=$HOME

source _activate_current_env.sh

exec "\$@"
EOF

cat > /root/.condarc <<-EOF
channels:
  - defaults
show_channel_urls: true
default_channels:
  - http://mirrors.aliyun.com/anaconda/pkgs/main
  - http://mirrors.aliyun.com/anaconda/pkgs/r
  - http://mirrors.aliyun.com/anaconda/pkgs/msys2
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2

custom_channels:
  conda-forge: http://mirrors.aliyun.com/anaconda/cloud
  msys2: http://mirrors.aliyun.com/anaconda/cloud
  bioconda: http://mirrors.aliyun.com/anaconda/cloud
  menpo: http://mirrors.aliyun.com/anaconda/cloud
  pytorch: http://mirrors.aliyun.com/anaconda/cloud
  simpleitk: http://mirrors.aliyun.com/anaconda/cloud
EOF

micromamba clean -i

micromamba install -y -n base -f model-resource/environment.yml && \
    micromamba clean --all --yes
