(load-file "threading.cj")

(def a (ref 1000000))
(def b (ref 0))

(defn transfer [from to]
  (ref-set from (- (deref from) 1))
  (ref-set to (+ (deref to) 1)) )

(defn move [from to]
  (dosync
   (if (> (deref from) 0)
     (transfer from to)) )
  (if (> (deref from) 0)
    (recur from to)) )

(defn show-account []
  (println "Account A is: " (deref a))
  (println "Account B is: " (deref b)) )

(defn reset-account []
  (dosync (ref-set a 1000000)
          (ref-set b 0) ))

(defn go []
  (let [ tasks (take 10 (cycle [(fn [] (move a b))])) ]
    (run-tasks tasks)
    (show-account) ) )
