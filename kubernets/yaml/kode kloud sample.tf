#https://medium.com/containers-on-aws/aws-app-mesh-walkthrough-deploy-the-color-app-on-amazon-ecs-de3452846e9d

Name: webapp
Image Name: kodekloud/event-simulator
Volume HostPath: /var/log/webapp
Volume Mount: /log

apiVersion: v1
kind: Pod
metadata:
  name: webapp
spec:
  containers:
  - name: 
    image: kodekloud/event-simulator
    volumeMounts:
    - name: volume
      mountPath: /log
  volumes:
  - name: volume
    hostPath:
      path: /var/log/webapp
      type: Directory


Volume Name: pv-log
Storage: 100Mi
Access modes: ReadWriteMany
Host Path: /pv/log

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /pv/log


Volume Name: claim-log-1
Storage Request: 50Mi
Access modes: ReadWriteMany 


apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim-log-1
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 50Mi


Name: webapp
Image Name: kodekloud/event-simulator
Volume: PersistentVolumeClaim=claim-log-1
Volume Mount: /log


apiVersion: v1
kind: Pod
metadata:
  name: webapp
  namespace: default
spec:
  restartPolicy: Never
  volumes:
    - name: vol
      persistentVolumeClaim:
        claimName: pv
  containers:
  - name: webapp
    image: kodekloud/event-simulator
    volumeMounts:
    - name: vol
      mountPath: /log








=======
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim


ConfigName Name: webapp-config-map
Data: APP_COLOR=darkblue
=============================
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-config-map
data:
  APP_COLOR: darkblue
spec.containers-->
envFrom:
      - configMapRef:
          name: special-config

#ADDING context to config file
-  context: 
    cluster: test-cluster-1
    user: dev-user
  name: guna

dev-user@test-cluster-1
    kubectl config use-context dev-user@test-cluster-1 --kubeconfig=/root/my-kube-config 


Role: developer
Role Resources: pods
Role Actions: list
Role Actions: create
ClusterRole: storage-admin
Resource: persistentvolumes
Resource: storageclasses
ClusterRoleBinding: michelle-storage-admin
ClusterRoleBinding Subject: michelle
ClusterRoleBinding Role: storage-admin



apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: storage-admin
rules:
- apiGroups: [""]
  resources: ["persistentvolumes"]
  verbs: ["*"]
- apiGroups: [""]
  resources: ["storageclasses"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
# This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
kind: ClusterRoleBinding
metadata:
  name: michelle-storage-admin
subjects:
- kind: user
  name: michelle # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: storage-admin
  apiGroup: rbac.authorization.k8s.io



kubectl create deployment web --image=myprivateregistry.com:5000/nginx:alpine

Name: private-reg-cred
Username: dock_user
Password: dock_password
Server: myprivateregistry.com:5000
Email: dock_user@myprivateregistry.com

kubectl create secret docker-registry private-reg-cred --docker-server=myprivateregistry.com:5000 --docker-username=dock_user --docker-password=dock_password --docker-email=dock_user@myprivateregistry.com
kubectl get secret private-reg-cred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
myprivateregistry.com:5000/Pull Secret:private-reg-cred


pod
=====
 imagePullSecrets:
  - name: private-reg-cred

Policy Name: internal-policy
Policy Types: Egress
Egress Allow: payroll
Payroll Port: 8080
Egress Allow: mysql
MYSQL Port: 3306


#network to connect from pod (name: internal) --> 1. pod (name: mysql) on port 3306
#  NetworkPolicy bound around pod () --> label    2. pod (name: payroll) on port 8080

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      name: internal
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          name: mysql
    ports:
    - protocol: TCP
      port: 3306

  - to:
    - podSelector:
        matchLabels:
          name: payroll
    ports:
    - protocol: TCP
      port: 8080