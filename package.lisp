;;;; package.lisp
;;;;
;;;; Copyright (c) 2017 Jeremiah LaRocco <jeremiah.larocco@gmail.com>

(defpackage #:fractal-gl
  (:use #:cl #:alexandria #:3d-vectors #:3d-matrices)
  (:export #:mandelbrot-viewer))

