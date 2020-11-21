# Mosquitto

This Chart bootstraps a Eclipse-Mosquitto Deployment center/t3n/mosquitto from chartcenter:

https://chartcenter.io/t3n/mosquitto

## Pull the Chart

```
helm pull center/t3n/mosquitto
tar xvfz mosquitto-2.2.0.tgz
cd mosquitto
```

## Configuration

See the required values and explanations in values.yaml, search for "changed" phrase in the values.yaml to see what has been configured.

## Deployment

```
helm upgrade --install mosquitto center/t3n/mosquitto -f values.yaml
```

## Related resources

[values.yaml](https://github.com/t3n/helm-charts/blob/master/mosquitto/values.yaml)

https://chartcenter.io/t3n/mosquitto

Blog Post

https://medium.com/cloudnesil/securing-mqtt-broker-on-kubernetes-5503420b84a8

Chart CloudNesil

https://github.com/CloudNesil/eclipse-mosquitto-mqtt-broker-helm-chart

MQTT GUI

http://www.jensd.de/apps/mqttfx/1.7.0/

