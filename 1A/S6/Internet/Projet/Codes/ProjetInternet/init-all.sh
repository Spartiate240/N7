#!/bin/bash
sudo docker ps | grep bin | tr -s ' ' | cut -d' ' -f12 | xargs -I % sudo docker exec % init

