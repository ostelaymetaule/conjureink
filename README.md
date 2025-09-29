# conjureink
Starting work on automating deployment for the homepage conjure.ink
Staging is located on test.conjure.ink


## tech
Currently the idea is to automaticaly deploy the site as a bunch of containers built with github actions and deployed with k3s. The ssl certificate for the subdomains is provided by letsencrypt and configured via jetstack/cert-manager.

The application is running on top of microsoft aspnet:8.0 docker image, with additional libraries for image manipulation. The container itself is then spun up in k3s, there are two namespaces separating production and staging resources.

The application is written using blazor client-server, that causes some reconnection issues on the mobile view when the website was minimized and then re-opened, for some reason, instead of refreshing automatically.


## possible low prio improvements
It would be interesting to be able to set up the vm infrastructure automatically using for example ansible, but thats not a must