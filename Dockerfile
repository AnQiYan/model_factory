FROM mambaorg/micromamba:0.27-jammy
ARG MODEL_TYPE=model_code
ARG MODEL_CODE=model_code
ARG MODEL_VERSION=model_version
ARG MODEL_INSTANCE=model_instance
ARG MODEL_HOME=/opt/model

USER root:root
RUN mkdir -p $MODEL_HOME
#将模型文件包解压到/opt/model目录
ADD your_model_package.tgz $MODEL_HOME

ENV ENV_MODEL_TYPE=$MODEL_TYPE
ENV ENV_MODEL_CODE=$MODEL_CODE
ENV ENV_MODEL_VERSION=$MODEL_VERSION
ENV ENV_MODEL_INSTANCE=$MODEL_INSTANCE
ENV ENV_MODEL_HOME=$MODEL_HOME
ENV MAMBA_USER=root
#VOLUME $MODEL_HOME/model-resource/model-config.yaml

WORKDIR $MODEL_HOME
RUN $MODEL_HOME/model-resource/image-build-start.sh
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN \cp -rfv system/* -t /		#使用system目录覆盖系统根目录
# >>>此处是模型管理工厂其他镜像生成动作
RUN $MODEL_HOME/model-resource/image-build-end.sh
EXPOSE 80
ENTRYPOINT ["model-resource/_entry_point.sh"]

