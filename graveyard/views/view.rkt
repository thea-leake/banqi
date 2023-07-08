;; Copyright 2019 Thea Leake

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;; http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

#lang racket/base

(provide board-table
         player-display
         player-message
         game-window)

(require (only-in racket/string
                  string-join)
         (only-in racket/class
                  new
                  send)
         (only-in racket/gui/base
                  frame%
                  message%
                  dialog%
                  button%
                  canvas%
                  pane%
                  vertical-pane%)
         (only-in table-panel
                  table-panel%)
         (prefix-in b: "../models/board.rkt")
         (prefix-in c: "colors.rkt")
         (prefix-in i: "images.rkt"))


(define start-message
  (string-join (list
                "First player - "
                "turn up a piece to find"
                " which team you're on!" )))

(define game-window
  (new frame%
       [label "Graveyard"]
       [stretchable-width #f]
       [stretchable-height #f]))

(define game-pane
  (new pane%
       [parent game-window]))


(define vert-arranger
  (new vertical-pane%
       [parent game-pane]))


(define board-container vert-arranger)



(define welcome-message
  (new canvas%
       [parent board-container]
       [min-height 20]
       [paint-callback (lambda (me dc)
                         (send dc
                               draw-bitmap
                               i:welcome-bitmap
                               (- (quotient (send me get-width ) 2)
                                  (quotient (send i:welcome-bitmap get-width) 2))
                               0))]))

(send welcome-message set-canvas-background c:electric-ultramarine)

(define player-display-table
  (new table-panel%
       [parent board-container]
       [dimensions '(1 2)]
       [column-stretchability #f]
       [row-stretchability #f]
       [alignment (list 'center 'top)]))


(define player-display
  (new message%
       [parent player-display-table]
       [label (string-join (list
                            "Current Necromancer:"
                            start-message))]))


(define player-message
  (new message%
       [parent player-display-table]
       [label start-message]))


(define board-table
  (new table-panel%
       [parent board-container]
       [border 2]
       [stretchable-width #f]
       [stretchable-height #f]
       [dimensions (list b:board-rows b:board-columns)]
       [alignment (list 'center 'bottom)]))


(define captured-window
  (new frame%
       [label "Unfirmary"]))

(define captured-vert-arranger
  (new vertical-pane%
       [parent captured-window]))

