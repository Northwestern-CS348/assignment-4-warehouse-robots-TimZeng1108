(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
	)

	(:action startShipment
		:parameters (?s - shipment ?o - order ?l - location)
		:precondition 
			(and 
				(unstarted ?s) 
				(not (complete ?s)) 
				(ships ?s ?o) 
				(available ?l) 
				(packing-location ?l)
			)
		:effect 
			(and 
				(started ?s) 
				(packing-at ?s ?l) 
				(not (unstarted ?s)) 
				(not (available ?l))
			)
	)

	(:action startShipment
		:parameters (?s - shipment ?o - order ?l - location)
		:precondition 
			(and 
				(unstarted ?s) 
				(not (complete ?s)) 
				(ships ?s ?o) 
				(available ?l) 
				(packing-location ?l)
			)
		:effect 
			(and 
				(started ?s) 
				(packing-at ?s ?l) 
				(not (unstarted ?s)) 
				(not (available ?l))
			)
	)

    (:action robotMove
        :parameters (?r - robot ?src - location ?dst - location)
        :precondition 
            (and 
                (at ?r ?src)
                (no-robot ?dst)
                (connected ?src ?dst) 
            )
        :effect 
            (and 
                (at ?r ?dst)
                (not (at ?r ?src))
                (no-robot ?src) 
                (not (no-robot ?dst))
            )
    )

    (:action robotMoveWithPallette
        :parameters (?r - robot ?p - pallette ?src - location ?dst - location)
        :precondition 
            (and 
                (at ?r ?src) 
                (at ?p ?src) 
                (no-robot ?dst) 
                (no-pallette ?dst)
                (connected ?src ?dst) 
            )
        :effect 
            (and 
                (at ?r ?dst) 
                (at ?p ?dst) 
                (not (at ?r ?src))
                (not (at ?p ?src))
                (no-robot ?src) 
                (no-pallette ?src) 
                (not (no-robot ?dst)) 
                (not (no-pallette ?dst))
            )
    )

	(:action moveItemFromPalletteToShipment
		:parameters (?s - shipment ?o - order ?p - pallette ?si - saleitem ?l - location)
		:precondition 
			(and 
				(ships ?s ?o) 
				(orders ?o ?si) 
                (not (unstarted ?s))
				(started ?s) 
				(not (complete ?s)) 
                (packing-location ?l)
				(not (available ?l))
                (at ?p ?l)
                (contains ?p ?si)
				(packing-at ?s ?l) 
			)
		:effect 
			(and 
				(not (contains ?p ?si)) 
				(includes ?s ?si)
			)
	)

	(:action completeShipment
		:parameters (?s - shipment ?o - order ?l - location)
		:precondition 
			(and 
				(started ?s) 
				(not (complete ?s)) 
				(ships ?s ?o) 
				(not (available ?l))
				(packing-at ?s ?l)
				(packing-location ?l) 
			)
		:effect 
			(and 
				(complete ?s) 
				(not (packing-at ?s ?l)) 
				(not (started ?s)) 
				(available ?l)
			)
	)

)
