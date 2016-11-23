	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC :init: */
;
		;
		
	case 4: // STATE 2
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 5: // STATE 3
		;
		((P2 *)this)->_6_2_i = trpt->bup.oval;
		;
		goto R999;

	case 6: // STATE 9
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 7: // STATE 11
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Centralita */

	case 8: // STATE 1
		;
	/* 0 */	((P1 *)this)->i = trpt->bup.ovals[2];
		XX = 1;
		unrecv(now.ctr, XX-1, 0, ((P1 *)this)->estado, 1);
		unrecv(now.ctr, XX-1, 1, ((P1 *)this)->i, 0);
		((P1 *)this)->estado = trpt->bup.ovals[0];
		((P1 *)this)->i = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 9: // STATE 2
		;
	/* 0 */	((P1 *)this)->estado = trpt->bup.oval;
		;
		;
		goto R999;

	case 10: // STATE 5
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Vecino */

	case 11: // STATE 1
		;
	/* 0 */	((P0 *)this)->id = trpt->bup.ovals[1];
		XX = 1;
		unrecv(now.ctr, XX-1, 0, 5, 1);
		unrecv(now.ctr, XX-1, 1, ((P0 *)this)->id, 0);
		((P0 *)this)->id = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 12: // STATE 6
		;
		XX = 1;
		unrecv(now.ctr2v[ Index(((P0 *)this)->id, 5) ], XX-1, 0, ((P0 *)this)->estado, 1);
		unrecv(now.ctr2v[ Index(((P0 *)this)->id, 5) ], XX-1, 1, ((P0 *)this)->i, 0);
		((P0 *)this)->estado = trpt->bup.ovals[0];
		((P0 *)this)->i = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 13: // STATE 7
		;
	/* 0 */	((P0 *)this)->estado = trpt->bup.oval;
		;
		;
		goto R999;

	case 14: // STATE 8
		;
		_m = unsend(now.ctr2v[ Index(((P0 *)this)->id, 5) ]);
		;
		goto R999;
;
		
	case 15: // STATE 9
		goto R999;

	case 16: // STATE 13
		;
		p_restor(II);
		;
		;
		goto R999;
	}

