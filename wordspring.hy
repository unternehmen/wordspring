(require hy.contrib.loop)
(import [random    [choice]]
        [functools [partial]])

(defn each [proc it]
  (for [x it] (proc x)))

(defn interp [unit]
  (loop [[unit unit]]
    (if (symbol? unit)
          (string unit)
        (and (iterable? unit) (empty? unit))
          ""
        (and (iterable? unit) (not (empty? unit)))
          (if (= '| (first unit))
                (->
                  (rest unit)
                  (list)
                  (choice)
                  (recur))
              (reduce
                (fn [acc unit]
                  (+ acc (interp unit)))
                unit
                ""))
        "")))

(defmain [&rest args]
  (let [C '(| k g t d f v s z m n l r q x p b)
        V `(| ~@(repeat 'a 10) e i o u o ö)
        E '(| st th fth ft lk lg ())
        S `(~C ~V)
        P `(| (~S ~S ~S) (~S ~S) (~S ~E))]
    (->>
      (partial interp P)  ; Make a compiler from the pattern to words.
      (repeatedly)        ; Create an infinite stream of words.
      (distinct)          ; Make sure all words are distinct.
      (take 100)          ; Number of words to generate.
      (each print))))     ; Print out the generated words.
