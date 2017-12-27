;;;; fractal-gl.asd
;;;;
;;;; Copyright (c) 2017 Jeremiah LaRocco <jeremiah.larocco@gmail.com>

(asdf:defsystem #:fractal-gl
  :description "Describe fractal-gl here"
  :author "Jeremiah LaRocco <jeremiah.larocco@gmail.com>"
  :license "ISC"
  :depends-on (#:clgl #:alexandria #:3d-vectors #:3d-matrices)
  :serial t
  :components ((:file "package")
               (:file "fractal-gl")))

