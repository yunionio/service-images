k8s:
	packer build ./kubernetes/k8s-centos7.json

clean:
	rm -rf _output

.PHONY: k8s clean
