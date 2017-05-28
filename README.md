# RBender [![Code Climate](https://codeclimate.com/github/art2rik/rbender/badges/gpa.svg)](https://codeclimate.com/github/art2rik/rbender)
**RBender** is a DSL-specified framework to create bots on different platforms (now Telegram only supported). Framework are developed to be maximally comfortable and intuitive for developers and proposes ultimate tools for bot creation.

![](https://github.com/art2rik/rbender/blob/master/img/rbender.png "Logo")
## Current gem version
[![Gem Version](https://badge.fury.io/rb/rbender.svg)](https://badge.fury.io/rb/rbender)

## Features
* Domain Specific Language based
* FSM (Final State Machine) model
* Logically encapsulated codee
* Simple, clear and powerfull
* Supports Telegram
* WEB-like sessions


## Future features
* Logger
* i18n support

# Getting started
## Before install
To use this framework you need MongoDB installed. Please [visit MongoDB website](https://docs.mongodb.com/manual/installation/) for more information.

## Install
```bash
gem install rbender
```
## FSM intro

The *Rbender* framework based on [Final State Machine](https://en.wikipedia.org/wiki/Finite-state_machine) model. Every state a represents one set of actions, which user could do while in state. The main idea of *RBender* are describing states and their's inner structure.

Every state can include:
* Keyboard
* One or more inline keyboards
* Text/Audio/Video hooks
* Before/After hooks
* Helper methods

The first state where user should be after '/start' command is **start** state.


For example, this code redirects user to **:state_1** after *:start* state code has been executed.
```ruby
state :start do
  after do
    switch(:state_1)
    # used to change states
  end
end

state :state_1 do
  # ...
  # some code
  # ...
end
```
User's state before execution:

![](https://github.com/art2rik/rbender/blob/master/img/fsm1.png "Before")

User's state after execution:

![](https://github.com/art2rik/rbender/blob/master/img/fsm2.png "After")

Beside this, there are can be **global** state where you can define helper methods and command hooks.

# Create your first bot
## States
### Start state
### Other states
### Global state
## Hooks
### Before/After
### Typed hooks
### Commands hook
## Keyboard
## Inline keyboards
## API methods
## Helpers
## Example

# Documentation
For detailed documentation [please visit our wiki](https://github.com/art2rik/RBender/wiki).

# RBender based projects
*RBender* widely used for e-commerce bot creation. There are at least one professional team, which successful integrated *RBender* into their work and uses the framework to create commercial bots ([Anybots team](https://t.me/anybots), Telegram: [@spiritized](https://telegram.me/spiritized)). Also, *RBender* is used for [inner-communication bots inside Innopolis city (Russia)](https://hightech.fm/2017/04/01/innopolis_bots).
## Bot examples
* [@HighTechFmBot](https://telegram.me/HighTechFmBot): [HighTech.FM](https://hightech.fm) media journal bot
* [@FintechRankingbot](https://telegram.me/FintechRankingbot): [FintechRanking](https://fintechranking.com) news bot
* [@icecakemoscowbot](https://telegram.me/icecakemoscowbot): Food delievery bot

## Badge for developers
![](https://github.com/art2rik/rbender/blob/master/img/madewithrbender.png "Stamp")
