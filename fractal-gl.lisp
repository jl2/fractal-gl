;;;; fractal-gl.lisp
;;;;
;;;; Copyright (c) 2017 Jeremiah LaRocco <jeremiah.larocco@gmail.com>

(in-package #:fractal-gl)

(defclass mandelbrot-set (primitives)
  ((minimum :initform #C(-1.0 -1.5) :initarg min)
   (maximum :initform #C(-1.0 -1.5) :initarg max))
  (:documentation "A set of primitives that all use the same shaders."))

(defmethod fill-buffers ((object mandelbrot-set))
  (call-next-method)
  (with-slots (vao vbos ebos filled-triangles) object
    (when (null vbos)
      (setf vbos (gl:gen-buffers 1))
      (setf ebos (gl:gen-buffers 4)))

    (let ((gl-vertices (to-gl-float-array filled-vertex-data)))
      (gl:bind-buffer :array-buffer (car vbo))
      (gl:buffer-data :array-buffer :dynamic-draw gl-vertices)
      (gl:free-gl-array gl-vertices))

    (loop
       for indices in (list filled-triangles)
       for ebo in (cddr ebos)
       do
         (let ((gl-indices (to-gl-array indices :unsigned-int)))
           (gl:bind-buffer :element-array-buffer ebo)
           (gl:buffer-data :element-array-buffer :static-draw gl-indices)
           (gl:free-gl-array gl-indices)))))

(defun add-filled-triangle (object pt1 pt2 pt3 color)

  (declare (type primitives object)
           (type point pt1 pt2)
           (type color color))

  (let ((normal (triangle-normal pt1 pt2 pt3)))
    (with-slots (filled-vertex-data filled-triangles) object
      (vector-push-extend (insert-pnc-in-buffer filled-vertex-data
                                                pt1
                                                normal
                                                color)
                          filled-triangles)
      (vector-push-extend (insert-pnc-in-buffer filled-vertex-data
                                                pt2
                                                normal
                                                color)
                          filled-triangles)
      (vector-push-extend (insert-pnc-in-buffer filled-vertex-data
                                                pt3
                                                normal
                                                color)
                          filled-triangles))))



(defmethod render ((object primitives) viewport frame)
  (declare (ignorable frame))
  (call-next-method)
  (with-slots (vbos ebos transformation points lines triangles filled-triangles shader-programs) object
    (when (and vbos ebos)
      (gl:bind-buffer :array-buffer (cadr vbos))
      (use-program (cadr shader-programs) transformation viewport)
      (gl:polygon-mode :front-and-back :fill)
      (gl:bind-buffer :element-array-buffer (filled-ebo ebos))
      (gl:draw-elements :triangles (gl:make-null-gl-array :unsigned-int) :count (length filled-triangles)))))
