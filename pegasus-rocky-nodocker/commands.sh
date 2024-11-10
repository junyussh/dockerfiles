# export proxy_path=http://10.89.0.2:7890
# envsubst < env.list > env.resolved.list
docker run -itd --hostname pegasus-rocky\
	--privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --name pegasus-rocky \
        -v "$(realpath .)/root:/root:Z" \
        -v "$(realpath .)/workflows:/workflows:Z" \
        -v "$HOME:/cjy" \
        my/pegasus-rocky
        