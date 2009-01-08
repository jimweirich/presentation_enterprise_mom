(load-file "threading.cj")

(def account (ref 0))

(defn bump-account []
  (dosync
   (ref-set account (+ 1 (deref account))) ))

(defn bump-many [n]
  (bump-account)
  (if (> n 1) 
    (recur (- n 1)) ))

(defn show-account []
  (println "Account is: " (deref account))
  (println "Expected  : " (* 10 100000)) )  

(defn reset-account []
  (dosync (ref-set account 0)) )

(defn go []
  (let [ tasks (take 10 (cycle [(fn [] (bump-many 100000))])) ]
    (run-tasks tasks)
    (show-account) ) )

