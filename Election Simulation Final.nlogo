breed [ candidates candidate ]
breed [ voters voter ]

candidates-own [ rival
  looking-for-rival?
  campaign-manager
  popularity
  number-of-votes
  can-color
]

voters-own [ list-of-likeness list-of-candidates my-can voted ] ;creates two lists so that later we can associate likeness with a specific candidate

globals [ amount-of-ticks-since-last-media
number-of-candidates-looking-for-rivals
can-go ]

to effectiveness-change
  ask candidates [ set campaign-manager random 50 ]
end

to stop-voting
  set can-go 1 ;making sure that go doesn't run because go is in a forever loop
  let winner max-one-of candidates [ number-of-votes ] ;figuring out who the winner is
  user-message word "the winner is " winner ;sending a message to the user telling them who the winner is
end

to select-who-to-vote-for
    set voted true ;keeping track of who has voted
    let highest max list-of-likeness
    let which-can position highest list-of-likeness
    set my-can item which-can list-of-candidates ;credits for this line and the two lines above----Mx. Hansbery
    set xcor [xcor] of candidate my-can
    set ycor [ycor] of candidate my-can
    ask candidate my-can [
      set number-of-votes number-of-votes + 1 ]
    set color [color] of candidate my-can ;changing colour to be the same as the candidate they're voting for (visual representation)
end

to go
  if can-go = 1 [ stop ]
  ask voters with [ voted = false ] [
      if max list-of-likeness > 25 [ select-who-to-vote-for ]
     let c 0 ;; keep track of which candidate youre on
     while [ c < count candidates ] [ ;; loop through all of them
      ;; get the popularity of a specified candidate
      let can-pop [ popularity ] of candidate c
      ;; get candidate c's old likeness
      let old-likeness item c list-of-likeness
      ;; update their likeness by adding in popularity
      set list-of-likeness (replace-item c list-of-likeness ( old-likeness + can-pop))
      set c c + 1 ;; increase to the next candidate
      ;credits for lines above---Mx. Hansberry
    ] ]
 tick
  if ticks = how-many-ticks-until-voting-stops [ ;stops voting at set time
    stop-voting
    ]
 set amount-of-ticks-since-last-media amount-of-ticks-since-last-media + 1
 if amount-of-ticks-since-last-media = how-many-ticks-for-one-media [
    media
    set amount-of-ticks-since-last-media 0 ] ;keeps track of when it should release new media based on the slider
  if count voters = 0 [ stop-voting ]
end

to candidate-color
  let current-color random 140
  set color current-color
  let any-other-candidates-with-same-color candidates with [ color = current-color ]
  if any-other-candidates-with-same-color = nobody or color = white [ candidate-color ]
end

to setup
  ca
  set can-go 0 ;making sure go will run
  create-candidates number-of-candidates
  create-voters number-of-voters
  ask candidates [
    candidate-color
    let x -1
    set popularity random 50 * x
    if 50 < random 100 [ set popularity random 50 ]
    set shape "butterfly"
    set looking-for-rival? false
    set number-of-candidates-looking-for-rivals 0
    create-link-with one-of other candidates
    repeat 500 [ layout-spring turtles links 0.2 5 1 ] ;making the turtles arrange in a formation
    setxy 0.9 * xcor 0.9 * ycor ;keeping the candidates somewhat away from the border
    set campaign-manager random 50
    ]
  ask voters [
    set color white
    set shape "car"
    move-to one-of patches
    set list-of-likeness [ ] ;resetting list
    repeat number-of-candidates [ set list-of-likeness lput 0 list-of-likeness ] ;creating a variable in the list for every candidate there is
    set list-of-candidates [ ] ;resetting list
    let x 0
    repeat number-of-candidates [ set list-of-candidates lput x list-of-candidates ;ascending candidate numbers
    set x x + 1 ]
  ]
  ifelse number-of-pairs-of-rivals > ( number-of-candidates * 0.5 ) [ user-message "More pairs of rivals than pairs of candidates"
     set can-go 1 ] [
  ask n-of number-of-pairs-of-rivals candidates [
    set rival one-of candidates
    set looking-for-rival? true
    set number-of-candidates-looking-for-rivals number-of-candidates-looking-for-rivals + 1
    while [[looking-for-rival?] of rival or rival = nobody ] [ ;making sure that the rivals arent like a rival triangle (i.e. a pair of rivals only have each other as rivals)
    set rival one-of candidates ;the code won't run because the number of pairs is not appropriate
    ]
  ]
  ]
  reset-ticks
end


to media-blast
  repeat random 40 [ media ]
end

to influx-of-voters
    create-voters random 40 [
    set color white
    move-to one-of patches ;move to a patch
    set shape "car"
   repeat number-of-candidates [ set list-of-likeness lput 0 list-of-likeness ] ;creating a variable in the list for every candidate there is
  ] ;setting up new voters
end

to expose
  ask one-of candidates [
    let subtract random 300 - campaign-manager ;negative effect on popularity of those candidate(s)
    set popularity popularity - subtract
    if rival != nobody and rival != 0 [ ask rival [ set popularity popularity + subtract ] ] ] ;have the action inversely affect the candidate's(s') rival as well
end

to media
  ask voters with [ voted = false ] [
   let which-can random ( number-of-candidates - 1 ) ;select number that corresponds to candidate
   let good-or-bad one-of [-1 1] ;make the effect either positive or negative
   let old-likeness item which-can list-of-likeness
    set list-of-likeness (replace-item which-can list-of-likeness ( old-likeness + ( random 85 * good-or-bad ) )) ] ;credits of this line-----Mx. Hansberry
end

to charity-donation
  ask one-of candidates [
    let add random 300 + campaign-manager ;positive effect on popularity of those candidate(s)
    set popularity popularity + add
    if rival != nobody and rival != 0 [ ask rival [ set popularity popularity - add ] ] ] ;have the action inversely affect the candidate's(s') rival as well
end


; Copyright 2021 Sofia Grimm.
; See Info tab for nonexistent full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
18
22
81
55
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
99
23
165
56
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
14
66
173
99
number-of-candidates
number-of-candidates
3
139
5.0
1
1
NIL
HORIZONTAL

SLIDER
12
108
169
141
how-many-ticks-for-one-media
how-many-ticks-for-one-media
0
100
49.0
1
1
NIL
HORIZONTAL

SLIDER
9
191
171
224
number-of-voters
number-of-voters
0
100
50.0
1
1
NIL
HORIZONTAL

BUTTON
93
237
178
270
media blast
media-blast
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
6
237
86
270
NIL
expose
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
10
280
174
313
number-of-pairs-of-rivals
number-of-pairs-of-rivals
0
100
62.0
1
1
NIL
HORIZONTAL

BUTTON
21
325
157
358
charity donation
charity-donation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
364
174
397
how-many-ticks-until-voting-stops
how-many-ticks-until-voting-stops
100
1000000
1000000.0
1
1
NIL
HORIZONTAL

BUTTON
14
150
180
183
change all campaign managers effectiveness
effectiveness-change
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
692
24
988
69
Number of candidates with positive popularity
count candidates with [ popularity > 0 ]
0
1
11

BUTTON
25
404
158
437
NIL
influx-of-voters
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
16
449
177
482
manually stop voting
stop-voting
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
218
465
335
498
manual media
media\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

With elections being a fascinatingly complex phenomenon, this model seeks to explore the effect of external factors such as media, existing influence, and campaign managers on elections.

## HOW IT WORKS

Every voter has a certain amount of liking of each candidate, and if their liking of a candidate becomes greater than 85, they vote for the said candidate. Voters' liking of each candidate is dictated by the sum of the candidate's popularity and the voter's own view of them. Candidate's popularity after set up ranges from -50 to 50, and can be changed if the expose or charity donation buttons are clicked, or if their rival's popularity changes. If the expose button is clicked, a candidate's popularity will be decreased by the difference between a number between 0-300 and the effectiveness of their campaign manager (the effectiveness of a campaign manager ranges from 0-50). If the charity donation button is clicked, a candidate's popularity will be increased by the sum of a number between 0-300 and the effectiveness of their campaign manager. Whenever a candidate's popularity changes, their rival's (if they have one) popularity changes inversely by the same amount. A voter's  view of a candidate is originally set to 0 and can be changed by clicking media or media blast button. If the media button is clicked, it will either positively or negatively affect the voter's view of a candidate. If the media blast button is clicked, it will repeat media up to 40 times. Voting can end in two ways: if the manually stop voting button is clicked or if the amount of simulated time that has gone by reaches the amount of simulated time that can go by before voting has to end as stipulated by the slider 'how-many-ticks-until-voting-stops' on the interface.

## HOW TO USE IT

Setting up the simulation:
Set the sliders to the values you would like them to have.
To start the simulation, click setup. Once setup is completed, click go.

While the simulation is running:
To negatively impact a random candidate's popularity, click expose. 
To positively impact a random candidate's popularity, click charity donation. 
To impact a voter's view of a candidate, click media or media blast.

To stop the simulation:
Click manually stop OR wait until the amount of ticks has reached the number you set on the "how-many-ticks-until-voting-stops' slider.

## THINGS TO NOTICE OR OBSERVE

-Candidates tend to retain their original popularity.
-It takes a considerable amount for the voters to vote, likely because of the level of likeness needed to vote.
-How does the number of candidates affect how quickly voters vote?

## CREDITS AND REFERENCES

Mx. Hansberry

## COPYRIGHT

nonexistent copyright © Sofia Grimm 2021
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
