/-  spider
/+  strandio
=>
|%
+$  result  [=ship time=(each @dr %timeout)]
++  do-pokes
  |=  [now=@da bytes=@ud ships=(list ship)]
  =/  m  (strand:rand ,~)
  ^-  form:m
  =/  msg=@t  (fil 3 bytes %a)
  =/  cards=(list card:agent:gall)
    %+  turn  ships
    |=  =ship
    ^-  card:agent:gall
    [%pass /(scot %p ship) %agent [ship %hood] %poke helm-hi+!>(msg)]
  ;<  ~  bind:m  (send-raw-cards:strandio cards)
  (pure:m ~)
::
++  looper
  |=  [now=@da ships=(set ship) results=(list result)]
  =/  m  (strand:rand ,(list result))
  ^-  form:m
  ;<  ures=(unit result)  bind:m  (take-result now ships)
  ?~  ures
    %-  pure:m
    %-  weld
    :_  results
    ^-  (list result)
    %+  turn  ~(tap in ships)
    |=  =ship
    [ship %| %timeout]
  =.  ships  (~(del in ships) ship.u.ures)
  ?~  ships
    (pure:m [u.ures results])
  $(results [u.ures results])
::
++  take-result
  |=  [now=@da ships=(set ship)]
  =/  m  (strand:rand ,(unit result))
  ^-  form:m
  |=  tin=strand-input:rand
  ?+  in.tin  `[%skip ~]
      ~  `[%wait ~]
      [~ %sign [%timeout ~] %behn %wake *]  `[%done ~]
      [~ %agent * %poke-ack *]
    ?.  ?=([@ ~] wire.u.in.tin)
      `[%skip ~]
    =/  =result  [(slav %p i.wire.u.in.tin) %& (sub now.bowl.tin now)]
    ?.  (~(has in ships) ship.result)
      `[%skip ~]
    `[%done `result]
  ==
::
++  set-timer
  |=  [now=@da timeout=@dr]
  =/  m  (strand:rand ,~)
  ^-  form:m
  =/  =card:agent:gall  [%pass /timeout %arvo %b %wait (add timeout now)]
  (send-raw-card:strandio card)
--
^-  thread:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
^-  form:m
=+  !<([~ timeout=@dr bytes=@ud ships=(list ship)] arg)
;<  now=@da  bind:m  get-time:strandio
;<  ~  bind:m  (set-timer now timeout)
;<  ~  bind:m  (do-pokes now bytes ships)
;<  results=(list result)  bind:m  (looper now (~(gas in *(set ship)) ships) ~)
(pure:m !>(results))
