#lang typed/racket/base
(require racket/math)
(require math/array)
(require math/base)
(require math/matrix)

;; TODO: make this work for an arbitrary amount of nodes, and with any given data

;; # of nodes in each layer (for each training sample)
(define n #(2 3 3 1))

(: random-number-std (-> Real Real (Listof Number)))
(define (random-number-std u1 u2)
  (list (* (sqrt (* -2 (log u1))) (cos (* 2 pi u2)))
        (* (sqrt (* -2 (log u1))) (sin (* 2 pi u2)))))
(random-number-std (random) (random))

;; I don't have numpy in racket lmao
(: make-random-array (-> Natural Natural (Array Number)))
(define (make-random-array columns rows)
  (build-array (vector columns rows)
               (lambda ([x : (Vectorof Index)])
                 (car (random-number-std (random) (random))))))

;; weights and biases
(define W1 (make-random-array (vector-ref n 1) (vector-ref n 0)))
(define W2 (make-random-array (vector-ref n 2) (vector-ref n 1)))
(define W3 (make-random-array (vector-ref n 3) (vector-ref n 2)))
(define b1 (make-random-array (vector-ref n 1) 1))
(define b2 (make-random-array (vector-ref n 2) 1))
(define b3 (make-random-array (vector-ref n 3) 1))

;; training data for the model (in this case)
(define training-data
  (array #[#[150 70]
           #[254 73]
           #[312 68]
           #[120 60]
           #[154 61]
           #[212 65]
           #[216 67]
           #[145 67]
           #[184 64]
           #[130 69]]))

;; properly transposed data
(define A0 (array-axis-swap training-data 0 1))

;; actual data, represented as a column vector
(define y
  (array #[#[0]
           #[1]
           #[1]
           #[0]
           #[0]
           #[1]
           #[1]
           #[0]
           #[0]]))
(define m 10) ; amount of training samples

;; activation function
(: sigmoid (-> (Array Number) (Array Number)))
(define (sigmoid array)
  (array-map (lambda ([x : Number]) 
               (/ 1 (+ 1 (exp (* -1 x))))) 
             array))

;; debug later (I'm so tired)
(define Z1 (matrix+ (matrix* W1 A0) b1))
(define A1 (sigmoid Z1))
(define Z2 (matrix+ (matrix* W2 A1) b2))
(define A2 (sigmoid Z2))
(define Z3 (matrix+ (matrix* W3 A2) b3))
(define A3 (sigmoid Z3))
(define y-hat A3)
y-hat

