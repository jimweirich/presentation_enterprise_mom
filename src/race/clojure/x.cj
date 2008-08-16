(import '(java.util.concurrent Executors))
(defn test-stm [nitems nthreads niters]
  (let [refs  (map ref (replicate nitems 0))
        pool  (. Executors (newFixedThreadPool nthreads))
        tasks (map (fn [t]
                       (fn []
                           (dotimes n niters
                             (dosync
                              (doseq r refs
                                (alter r + 1 t))))))
                   (range nthreads))]
    (doseq future (. pool (invokeAll tasks))
      (. future (get)))
    (. pool (shutdown))
    (map deref refs)))
(test-stm 10 10 10000)
