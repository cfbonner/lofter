#!/bin/bash

mix deps.get
mix deps.compile

cd assets && npm install && cd ..

mix ecto.create
mix ecto.migrate

mix phx.server
