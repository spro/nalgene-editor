module.exports = '''
%
    ~ok? %response

%response
    %setState
    %gotTime
    %gotPrice
    %gotWeather
    %fallback

%fallback
    I'm not sure what happened.

%dontknow
    I don't understand.
    I didn't catch that.
    I don't know what you're saying.

%setState
    I turned the $device $state .
    I turned $state the $device .
    the $device is now $state .
    $devices are now $state .

%gotState
    the $device is $state .

%gotTime
    the time is $time .
    it is $time .

%gotPrice
    the price of $asset is ~currently? $price .
    $asset is ~currently? $price .

%gotWeather
    $location is ~currently? $temperature with $conditions .
    the $location $key is ~currently? $value .
    the $key of $location is ~currently? $value .

~currently
    currently

~ok
    ok,
    sure,
'''

module.exports = '''
%
    ~greeting? ~please? %command ~thanks? .
    ~greeting? ~please? %command and %command ~thanks? .
    ~greeting? ~please? %command and %command ~thanks? . also %command .

%command
    %order_food
    %set_device_state
    %get_device_state
    %get_weather
    %set_tv

%order_food
    ~order %food_item from $food_place
    ~order ~something from $food_place
    ~order %food_item

%set_device_state
    turn $state the $device
    turn the $device $state

%get_device_state
    ~tell_me the state of the $device

%get_weather
    ~tell_me the weather in $location
    ~tell_me what it's like in $location

%set_tv
    %set_tv_state and %set_tv_channel
    %set_tv_channel
    %set_tv_state

%set_tv_state
    turn $tv_state the ~tv

%set_tv_channel
    put %channel on

%channel
    #tv_channels|$tv_genre|$tv_sub_genre
    #tv_channels|$tv_genre

~tv
    TV
    television
    telly

~tell_me
    tell me
    let me know

~something
    something
    some food

%food_item
    ~some $food_item_plural
    a $food_item_singular

~some
    some

~order
    order
    order me
    get me

~greeting
    hey,
    hello there,
    hi Maia,

~please
    please
    could you
    would you
    I want you to

~thanks
    , thanks
    thank you
'''
