# Robotto [![Code Climate](https://codeclimate.com/github/art2rik/robotto/badges/gpa.svg)](https://codeclimate.com/github/art2rik/robotto)
**Robotto** is a DSL-specified framework to create bots for Telegram platform. Framework are developed to be maximally comfortable and intuitive for developers and proposes ultimate tools for bot creation.

![](https://github.com/art2rik/robotto/blob/master/img/robotto.png "Logo")
## Current gem version
[![Gem Version](https://badge.fury.io/rb/robotto.svg)](https://badge.fury.io/rb/robotto)

## Features
* Domain Specific Language based
* FSM (Final State Machine) model
* Logically encapsulated codee
* Simple, clear and powerfull
* WEB-like sessions


## Future features
* Logger
* i18n support
* Inline API support
* Game API support
* Payment support

# Getting started
## Before install
To use this framework you need MongoDB installed. Please [visit MongoDB website](https://docs.mongodb.com/manual/installation/) for more information.

## Install
```bash
~$ gem install robotto
```

## Usage

To create new project type in terminal:
```bash
~$ robotto new DemoBot
```
Then new project with templates will be created. 

To run your bot:
```bash
~$ cd DemoBot
~/DemoBot$ robotto start
```
## FSM intro

The *Rbender* framework based on [Final State Machine](https://en.wikipedia.org/wiki/Finite-state_machine) model. Every state a represents one set of actions, which user could do while in state. The main idea of *Robotto* are describing states and their's inner structure.

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

![](https://github.com/art2rik/robotto/blob/master/img/fsm1.png "Before")

User's state after execution:

![](https://github.com/art2rik/robotto/blob/master/img/fsm2.png "After")

Beside this, there are can be **global** state where you can define helper methods and command hooks.

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
* photo
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

  keyboard do
    keyboard_response = "This is a keyboard"
    set_response(keyboard_response) # Response is REQUIRED!!!
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

Inline Keyboards are similar to common keyboard, but it's must be attached to message. 

There are three button types in inline mode:
* Button – classic button with callback
* Link button – button with URL
* Inline switch button – switch to inline mode

```ruby
state :state_main do
  before do
    # Invoke inline keyboard
    send_message(text: "This is inline keyboard under this message",
                 reply_markup: inline_markup(:kb_sample))
  end
  
  keyboard_inline :kb_sample do
    button :btn_hello, "Hi!" do
      # Action callback
      edit_message(text: "Hello!")
    end
    
    button_link(:btn_url, 
                "Robotto homepage",
                https://github.com/art2rik/Robotto)
                
    add_line(:btn_hello)
    add_line(:btn_url)
  end
end
```

## Sessions
Sessions are special structure which stores different user's information. 

You could find out following data in the sessions:
```ruby
session[:state] # Current user's state
session[:lang] # Current user's language
session[:user][:chat_id] # User's chat id
session[:user][:user_name] # Telegram alias if available
session[:user][:first_name] 
session[:user][:last_name] # If available
```

Futhermore, you can contain your own values inside **session** variable to store parameters and other user's data, but keys above are reserved (also *:state_stack*, *:keyboard_switchers*, *:keyboard_switch_groups* are reserved too).

```ruby
  state :state_main do
    before do
      # Init new user's session parameter
      session[:notes] = [] 
    end
    
    text do
      # Add user's message to saved notes
      session[:notes].push(message.text)
    end  
  end
```
## Modules
Likely, you may want to expand your bot functionality by additional functionality modules. You can use *telegram api driver* and *mongodb driver* to use it in your own classes or modules. 

How to do it:
```ruby
modules do |api, mongo|
YourModule.set_api(api)
YourModule.set_mongo(mongo)
end
```
Robotto use [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) api driver and [MongoDB ruby](https://github.com/mongodb/mongo-ruby-driver) driver. Also you can get access to MongoDB driver like this:

```ruby
Robotto::Mongo.client
```
## Download/ Upload 
## Methods
### Robotto methods
#### General methods
| Method name| Arguments | Description|
|------------|------------|------------|
|state| **state_id** * *Symbol/String* id of a state <br> **&block** state block | Defines state |
|global| **&block** global state code block  | Defines global state|
|modules| — | Defines additional bot modules <br> *(Returns additional parameters api_driver and mongodb_driver)*|

#### In-state methods

Used in **state** block.

| Method name| Arguments | Description|
|------------|------------|------------|
|keyboard| **kb_response** *String* message displayed to user when keyboard has showed <br> **&block** keyboard code block| Defines keyboard |
|keyboard_inline| **keyboard_id** *Symbol/String* inline keyboard id <br> **&block** keyboard code block | Defines inline keyboard |
|after| **&block** hook block code | Hook invoked after state are changed |
|before| **&block** hook block code | Hook invoked before over hooks are executed  |
|text| **&block** hook block code | Hook invoked on text messages |
|audio| **&block** hook block code | Hook invoked on audio messages |
|photo <br> (*Aliases:* image, picture)| **&block** hook block code | Hook invoked on photos |
|video| **&block** hook block code | Hook invoked on video messages |
|voice| **&block** hook block code | Hook invoked on voice messages |
|document| **&block** hook block code | Hook invoked on document messages |
|location| **&block** hook block code | Hook invoked on location messages |
|contact| **&block** hook block code | Hook invoked on contact messages |
|animation| **&block** hook block code | Hook invoked on animation messages |
|sticker| **&block** hook block code | Hook invoked on sticker messages |
|chat| **&block** hook block code | Hook invoked on messages with chats |
|command| **command** command name <br> **&block** action callback| Defines global commands <bt> Throws *params* argument <br> *(global state only)* |
|helpers| **&block** block with defined helper methods | Defines helpers

#### Hooks/callbacks

Used inside hooks.

| Method name| Arguments | Description|
|------------|------------|------------|
|switch| **state_id** *Symbol* id of needed state | Changes state of user |
|switch_prev| – | Returns to previous state |
|inline_markup| **keyboard_id** *Symbol* id of required keyboard | Returns inline markup object
|session| – | Return user's session
|message| - | Returns last (usually actual) message object

#### Keyboard

Used inside keyboard block.

| Method name| Arguments | Description|
|------------|------------|------------|
|session| – | Return user's session
|button | **id** *Symbol* Id of button <br> **description** *String* value of button <br> **&action** callback | Adds button |
|add_line| **\*buttons** Ids of button | Adds buttons row to markup
|resize| - | Resizes button 
|one_time| - | Hide keyboard after use

#### Inline keyboard

Used inside keyboard_inline block.

| Method name| Arguments | Description|
|------------|------------|------------|
|session| – | Return user's session
|button | **id** *Symbol* Id of button <br> **description** *String* value of button <br> **&action** callback | Adds button |
|button_link| **id** *Symbol* Id of button <br> **description** *String* value of button <br> **link** URL | Adds URL-button
|button_inline| **id** *Symbol* Id of button <br> **description** *String* value of button <br> **query** *Query object* | Adds Inline Mode button
|add_line| **\*buttons** Ids of button | Adds buttons row to markup


### API methods
 Robotto supports all avalaible [Telegram Bot API methods](https://core.telegram.org/bots/api#available-methods). 
 But there are some litlle differences:
 * There are not necessary to specify user_id, you're always work with concrette user
 * Use *snake_case* instead CamelCase
 
 ```ruby
 state :state_main do
  before do
    send_message(text: "Some useless words")
    send_message(chat_id: session[:chat_id],
                 text: "Another useless text")
    # Both (!!!) messages will be delievered to the same user
  end
 end
 ```
## Helpers
Inside *helpers* block you could define helper methods inside your states.

```ruby

# You could define helpers visible inside a state only
state :state_main do
  kb_response = "Press any button"
  keyboard kb_response do
    button :btn_local, "Local helper" do
      local_helper_method()
    end
    
    button :btn_global, "Global helper" do
      global_helper_method()
    end
    
    add_line(:btn_local)
    add_line(:btn_global)
  end
  
  helpers do 
    def local_helper_method
      send_message(text: "Local helper method has been invoked")
    end
  end
end

# Or you could define global helper
global do
  helpers do
    def global_helper_method 
      send_message(text: "Global helper method has been invoked")
    end
  end
end
```
## Examples

# Documentation
For detailed documentation [please visit our wiki](https://github.com/art2rik/Robotto/wiki).

# Robotto based projects
*Robotto* widely used for e-commerce bot creation. There are at least one professional team, which successful integrated *Robotto* into their work and uses the framework to create commercial bots ([Anybots team](https://t.me/anybots), Telegram: [@spiritized](https://telegram.me/spiritized)). Also, *Robotto* is used for [inner-communication bots inside Innopolis city (Russia)](https://hightech.fm/2017/04/01/innopolis_bots).
## Bot examples
* [@HighTechFmBot](https://telegram.me/HighTechFmBot): [HighTech.FM](https://hightech.fm) media journal bot
* [@FintechRankingbot](https://telegram.me/FintechRankingbot): [FintechRanking](https://fintechranking.com) news bot
* [@icecakemoscowbot](https://telegram.me/icecakemoscowbot): Food delievery bot

## Badge for developers
![](https://github.com/art2rik/robotto/blob/master/img/madewithrobotto.png "Stamp")
