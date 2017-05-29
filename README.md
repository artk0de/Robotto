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
~$ gem install rbender
```

## Usage

To create new project type in terminal:
```bash
~$ rbender new DemoBot
```
Then new project with templates will be created. 

To run your bot:
```bash
~$ cd DemoBot
~/DemoBot$ rbender start
```
## FSM intro

The *Rbender* framework based on [Final State Machine](https://en.wikipedia.org/wiki/Finite-state_machine) model. Every state a represents one set of actions, which user could do while in state. The main idea of *RBender* are describing states and their's inner structure.

Every state can include:
* Keyboard
* One or more inline keyboards
* Text/Audio/Video/other hooks
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
States are main logical part of bot. 
States could be described as follow by using **state** keyword:
```ruby
state :start do
 # do some code
end

state :state_first do
  # do some code
end

state :state_second do
  # do some code
end

global do
  # do some code
end
```

**:start** state is required and is a main entry point.

**Global** state helps developers to define global inline keyboards, helpers and commands.

## Hooks
Hooks are callbacks which execututes when user sends to bot some different type messages like text/audio/video.

### Typed hooks
```ruby
state :state_main do
  text do
    # execetues when user sends text message
  end
  
  image do
    # executes when user sends picture
  end
  
  video do
    # executes when user sends video
  end
end
```
Available typed hooks:
* text
* audio
* video
* voice
* document
* location
* contact
* animation
* sticker
* chat

### Before/After
**Before** hook executes immediatly when user before state has changed.

**After** hook executes after state has changed

```ruby
state :state_one do
  text do
   switch(:state_second) if message == 'switch'
  end
  
  after do
    # executes before switch happens
  end
end

state :state_second do
  before do
    # executes when state will be :state_second 
  end
end
```

### Commands hook
Commands are messages begins with '/' symbol. Commands are availble from all states to user and should be described as follows
```ruby
global do
  command '/about' do
    send_message(text: "by Arthur Korochansky @art2rik")
  end
  
  command '/with_params' do |params|
    # f.e. if command was /with_params 1 one odin
    # params = [1, 'one', 'odin']
  end
end
```
## Keyboard
Every keyboard are assigned to single state and executes at the same time as state has changed.
```ruby
state :state_main do
  keyboard_response = "This is a keyboard"
  keyboard keyboard_response do
    button :btn_one, "One" do
      set_response("You've pressed ONE") # change keyboard response to user
      # action callback
    end
    
    button :btn_two, "Two" do
    set_response("You've pressed TWO")
      # action callback
    end
    
    button :btn_third, "Thrid" do
      set_response("You've pressed THIRD")
      # action callback
    end
    
    add_line(:btn_one, :btn_two) # put "one" and "two" buttons in first line
    add_line(:btn_third) # put "third" button in second line
    resize() # auto resize button
    one_time() # hide keyboard after use    
  end
end
```

## Inline keyboards
## Sessions
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
