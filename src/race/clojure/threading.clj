(import '(java.util.concurrent Executors))

(defn create-pool [n]
  (. Executors (newFixedThreadPool n)))

(defn run-tasks-in-pool [pool, tasks]
  (doseq [future (. pool (invokeAll tasks))]
    (. future (get)) )
  (. pool (shutdown)) )  

(defn run-tasks [tasks]
  (let [ pool (create-pool (count tasks)) ]
    (run-tasks-in-pool pool tasks) ))

(defn sleep [seconds]
  (. Thread (sleep (* 1000 seconds))))
