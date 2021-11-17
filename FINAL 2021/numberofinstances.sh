 c=$(ps -ef | grep $0 | egrep -v "grep|vi|more|pg" | wc -l)
print "cantidad de instancias = $c"