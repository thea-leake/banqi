;; Copyright 2019-2021 Thea Leake

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

(require (only-in racket/class
                  new
                  send
                  class
                  define/override
                  define/public
                  super-new
                  object?
                  init-field
                  this
                  inherit)
         (only-in racket/gui/base
                  canvas%)
         (prefix-in c: "colors.rkt")
         (prefix-in i: "images.rkt")
         (prefix-in s: "image_settings.rkt"))

(provide make-tile
         update-tile
         (struct-out location))


(struct location
  (tile
   piece
   coords))


(define tile-canvas%
  (class canvas%
    (inherit min-width min-height)
    (super-new)
    (init-field callback
                tile-image
                [style (list 'no-autoclear)])
    (define/public (store-image btmp)
      (set! tile-image btmp))
    (define/public (get-image)
      tile-image)
    (define (my-dc)
      (send this get-dc))
    (define/override (on-event e)
      (when (and (object? e) (send e button-down? 'left))
        (callback)))))

(define tile-paint-callback
  (lambda (me dc)
    (send dc
          draw-bitmap
          (send me get-image)
          0
          0)))

(define (make-tile parent callback coords)
  (let* ([image (i:hidden-tile-label coords)]
         [new-tile (new tile-canvas%
                         [parent parent]
                         [callback callback]
                         [min-width s:tile-width]
                         [min-height s:tile-height]
                         [tile-image image]
                         [paint-callback tile-paint-callback])])
    (send new-tile set-canvas-background c:dark-purple-taup)
    (send new-tile on-paint)
    new-tile))


(define (update-tile state tile)
  (let ([tile-img (i:get-tile-label state
                                      (location-piece tile)
                                      (location-coords tile))])
    (send (location-tile tile) store-image tile-img)
    (send (location-tile tile) on-paint)))

