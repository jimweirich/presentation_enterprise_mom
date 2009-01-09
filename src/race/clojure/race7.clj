(load-file "threading.clj")

(def a (ref 1000))
(def b (ref 1000))
(def c (ref 1000))
(def d (ref 1000))
(def e (ref 1000))

(defn transfer [from to]
  (sleep 0.5)
  (ref-set from (- (deref from) 1))
  (sleep 0.5)
  (ref-set to (+ (deref to) 1)) )
     
(defn move [from to]
  (dosync
   (if (> (deref from) 0)
     (transfer from to)) ))
  
(defn show-account []
  (println "Account A is: " (deref a))
  (println "Account B is: " (deref b)) 
  (println "Account C is: " (deref c)) 
  (println "Account D is: " (deref d)) 
  (println "Account E is: " (deref e)) )

(defn go []
  (let [ tasks (list (fn [] (move a b))
                     (fn [] (move b c))
                     (fn [] (move c d))
                     (fn [] (move d e))
                     (fn [] (move e a)) ) ]
    (run-tasks tasks)
    (show-account) ) )

(defn reset-account []
  (dosync (ref-set a 1000)
          (ref-set b 1000)
          (ref-set c 1000)
          (ref-set d 1000)
          (ref-set e 1000) ))
