FROM docker.artifactory.weedon.org.au/redwyvern/valheim-server:latest

ARG VHP_VERSION=0.9.7

USER root
COPY vhserver-default.cfg /opt/vhserver/lgsm/config-lgsm/vhserver/vhserver.cfg
RUN chown vhserver.vhserver /opt/vhserver/lgsm/config-lgsm/vhserver/vhserver.cfg

USER vhserver

RUN cd /opt/vhserver/serverfiles && \
    wget https://github.com/valheimPlus/ValheimPlus/releases/download/${VHP_VERSION}/UnixServer.tar.gz && \
    tar -xzpsf ./UnixServer.tar.gz && \
    rm UnixServer.tar.gz

# Move the Valheim+ config file to a persistent volume and replace with a symlink 
RUN cp /opt/vhserver/serverfiles/BepInEx/config/valheim_plus.cfg /opt/vhserver/lgsm/config-lgsm/vhserver && \
    rm /opt/vhserver/serverfiles/BepInEx/config/valheim_plus.cfg && \
    ln -s /opt/vhserver/lgsm/config-lgsm/vhserver/valheim_plus.cfg /opt/vhserver/serverfiles/BepInEx/config/valheim_plus.cfg

# Patch a erroneous line in the VH+ startup script
RUN sed -i 's/LD_LIBRARY_PATH=`.\/linux64:.*/export LD_LIBRARY_PATH=".\/linux64:$LD_LIBRARY_PATH"/g' /opt/vhserver/serverfiles/start_server_bepinex.sh

    



