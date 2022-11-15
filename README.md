<h1>模型工厂配置流程</h1>
<h2>前言：<br></h2>
重庆烟叶数字化转型模式探索与实践项目，将建设9个AI模型及1个模型管理工厂。
其中9个模型由4个不同的承建单位，共计3年时间里完成。项目计划通过模型管理工厂，对模型和模型应用实现管理。

<h2>背景</h2>

<h2>项目文件</h2>

![img_3.png](img_3.png)


<h3>项目文件主要有model_resource 和 system:<br></h3>
model_resource: 模型资源目录<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _entry_point.sh &nbsp;&nbsp;#镜像启动入口
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; image-build-end.sh &nbsp;&nbsp;#镜像制作结束脚本
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; image-build-start.sh &nbsp;&nbsp;#镜像制作开始脚本
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; model-config.yaml<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /code/  存放项目代码
<br>
system：系统资源目录用于覆盖系统配置<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; etc &nbsp; #例子:etc目录<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hosts  &nbsp;&nbsp;#例子：hosts文件


<h3>配置步骤</h3>
由于我们使用了<a href = "https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html"><b><i>micromamba</b></i></a>镜像（在Dockerfile中需要将基础镜像设置为&nbsp;<b>FROM mambaorg/micromamba:0.27-jammy</b>）

![img.png](img.png)

<h2>修改<b>image-build-start.sh</b>文件</h2>
<h3>1.我们需要将root用户更改为mamba以绕过其中的检测</h4>
<p>
echo "root" > "/etc/arg_mamba_user"<br>
export MAMBA_USER=root<br>
export USER="root"<br>
export HOME="/root"<br>

cat <<< $(readlink -e ~)<br>

cat > /usr/local/bin/_entrypoint.sh <<-EOF
<br>#!/usr/bin/env bash<br>
set -ef -o pipefail<br>

export USER=$USER<br>
export HOME=$HOME<br>

source _activate_current_env.sh<br>

exec "\$@"<br>
EOF<br>

</p>


<h3>2.添加镜像源来增加速度</h3>
<p>
cat > /root/.condarc <<-EOF<br>
channels:<br>
  - defaults<br>
show_channel_urls: true<br>
default_channels:<br>
&nbsp;&nbsp;- http://mirrors.aliyun.com/anaconda/pkgs/main<br>
&nbsp;&nbsp;- http://mirrors.aliyun.com/anaconda/pkgs/r<br>
&nbsp;&nbsp;- http://mirrors.aliyun.com/anaconda/pkgs/msys2<br>
&nbsp;&nbsp;- https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main<br>
&nbsp;&nbsp;- https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free<br>
&nbsp;&nbsp;- https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r<br>
&nbsp;&nbsp;- https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro<br>
&nbsp;&nbsp;- https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2<br>

custom_channels:<br>
&nbsp;&nbsp;conda-forge: http://mirrors.aliyun.com/anaconda/cloud <br>
&nbsp;&nbsp;msys2: http://mirrors.aliyun.com/anaconda/cloud <br>
&nbsp;&nbsp;bioconda: http://mirrors.aliyun.com/anaconda/cloud <br>
&nbsp;&nbsp;menpo: http://mirrors.aliyun.com/anaconda/cloud <br>
&nbsp;&nbsp;pytorch: http://mirrors.aliyun.com/anaconda/cloud <br>
&nbsp;&nbsp;simpleitk: http://mirrors.aliyun.com/anaconda/cloud <br>
EOF<br>


<h3>3.通过micromamba来安装需要的包</h3>(需要在model-resource下的environment.yml文件中说明需要使用的包)<br>

![img_5.png](img_5.png)

<h3>随手执行语句即可完成包的安装<br></h3>
micromamba clean -i<br>

micromamba install -y -n base -f model-resource/environment.yml && \ <br>
&nbsp;&nbsp;&nbsp;&nbsp;micromamba clean --all --yes<br>
</p>

<h3>现在我们就可以配置_entry_point.sh文件来说明需要启动的程序</h3>

![img_6.png](img_6.png)



<h2>通过docker来构建镜像</h2>