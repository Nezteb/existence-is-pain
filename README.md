# Existence Is Pain

The name is based off of [this memorable scene](https://youtu.be/ZA9Dvh4Fyf8?t=29s) from Rick & Morty.

This is going to be a large multiplayer version of the classic game Snake. The goal isn't to be original. I want to get some practice with multiplayer video game servers.

# Server

In order to learn and expand my knowledge, I'm going to attempt make the same backend in two different languages for learning purposes.

Some things I want to incorporate:
* Postgres
* Websockets
* RabbitMQ
* Redis
* User auth (Auth0, Google OAuth, Keycloak?, Ory Hydra?)
* Feature flags (ConfigCat)
* gRPC (with HTTP API bridge)
  * NATS?
* Apache Kafka/Pulsar?

## Elixir

Language-specific libs I will try to use:
* https://github.com/phoenixframework/phoenix
* https://github.com/elixir-ecto/ecto
* https://github.com/phoenixframework/phoenix_live_view
* https://github.com/rrrene/credo
* https://github.com/jeremyjh/dialyxir
* https://github.com/dashbitco/flow
* https://github.com/dashbitco/broadway
* https://github.com/dashbitco/mox
* https://github.com/ash-project/ash

## Kotlin:

Language-specific libs I will try to use:
* https://github.com/ktorio/ktor
* https://github.com/google/dagger
* https://github.com/JetBrains/Exposed
* https://github.com/arrow-kt/arrow
* https://github.com/lagom/lagom (Play/Akka)
* https://github.com/spring-projects/spring-framework

There might need to be 3 different endpoints for the Ktor/Dagger instance, the Lagom/Play/Akka instance, and the Spring instance.

# Client

One of the clients will use Phoenix LiveView (listed above). The purely browser-side clients is going to be the simplest part, mostly because I prefer to focus on the backend. I'll use TypeScript. I'd like to try two versions of the client:

- 2D: [Phaser.io](https://phaser.io/)
- 3D: [Three.js](https://threejs.org/)

Try to incorporate:
* Typescript
* React + React Router (use hooks)
* Yarn? Webpack?
* RxJS?
* Svelte?

TODO: Maybe use Haxe to program a client that can cross-compile to a bunch of different targets. 🤔

## Third Party Tools:

* Hosting: Heroku (with Postgres and RabbitMQ addons)
  * Self-hosting option: Docker/Minikube/Ansible?
* Logs: papertrail.com or timber.io

# Resources

* [Game Programming Patterns by Bob Nystrom](http://gameprogrammingpatterns.com/)

# FAQ

* Noah this is dumb.
  * [That's not a question.](https://www.youtube.com/watch?v=KIBw10VUcNQ&t=2s)
* Why Elixir/Kotlin?
  * Because that's what I'm interested in learning.
* Why TypeScript/Phaser/ThreeJS?
  * Because that's what I'm interested in learning.
* Why not XYZ?
  * Because I'm not interested in learning that right now.
