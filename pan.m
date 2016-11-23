#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC :init: */
	case 3: // STATE 1 - hola.pml:58 - [((i<5))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		if (!((((P2 *)this)->_6_2_i<5)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - hola.pml:58 - [(run Vecino(i))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		if (!(addproc(II, 1, 0, ((P2 *)this)->_6_2_i)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - hola.pml:58 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		(trpt+1)->bup.oval = ((P2 *)this)->_6_2_i;
		((P2 *)this)->_6_2_i = (((P2 *)this)->_6_2_i+1);
#ifdef VAR_RANGES
		logval(":init::i", ((P2 *)this)->_6_2_i);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 9 - hola.pml:61 - [(run Centralita())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][9] = 1;
		if (!(addproc(II, 1, 1, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 11 - hola.pml:63 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][11] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Centralita */
	case 8: // STATE 1 - hola.pml:43 - [ctr?estado,i] (0:0:3 - 1)
		reached[1][1] = 1;
		if (boq != now.ctr) continue;
		if (q_len(now.ctr) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P1 *)this)->estado;
		(trpt+1)->bup.ovals[1] = ((P1 *)this)->i;
		;
		((P1 *)this)->estado = qrecv(now.ctr, XX-1, 0, 0);
#ifdef VAR_RANGES
		logval("Centralita:estado", ((P1 *)this)->estado);
#endif
		;
		((P1 *)this)->i = qrecv(now.ctr, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Centralita:i", ((P1 *)this)->i);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.ctr);
		sprintf(simtmp, "%d", ((P1 *)this)->estado); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)this)->i); strcat(simvals, simtmp);		}
#endif
		if (q_zero(now.ctr))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		if (TstOnly) return 1; /* TT */
		/* dead 2: i */  (trpt+1)->bup.ovals[2] = ((P1 *)this)->i;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)this)->i = 0;
		_m = 4; goto P999; /* 0 */
	case 9: // STATE 2 - hola.pml:46 - [((estado==descolgado))] (0:0:1 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!((((P1 *)this)->estado==4)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: estado */  (trpt+1)->bup.oval = ((P1 *)this)->estado;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)this)->estado = 0;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 5 - hola.pml:52 - [-end-] (0:0:0 - 2)
		IfNotBlocked
		reached[1][5] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Vecino */
	case 11: // STATE 1 - hola.pml:18 - [ctr?sonando,id] (0:0:2 - 1)
		reached[0][1] = 1;
		if (boq != now.ctr) continue;
		if (q_len(now.ctr) == 0) continue;

		XX=1;
		if (5 != qrecv(now.ctr, 0, 0, 0)) continue;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P0 *)this)->id;
		;
		((P0 *)this)->id = qrecv(now.ctr, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Vecino:id", ((P0 *)this)->id);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.ctr);
		sprintf(simtmp, "%d", 5); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)this)->id); strcat(simvals, simtmp);		}
#endif
		if (q_zero(now.ctr))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		if (TstOnly) return 1; /* TT */
		/* dead 2: id */  (trpt+1)->bup.ovals[1] = ((P0 *)this)->id;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)this)->id = 0;
		_m = 4; goto P999; /* 0 */
	case 12: // STATE 6 - hola.pml:25 - [ctr2v[id]?estado,i] (0:0:2 - 1)
		reached[0][6] = 1;
		if (boq != now.ctr2v[ Index(((P0 *)this)->id, 5) ]) continue;
		if (q_len(now.ctr2v[ Index(((P0 *)this)->id, 5) ]) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P0 *)this)->estado;
		(trpt+1)->bup.ovals[1] = ((P0 *)this)->i;
		;
		((P0 *)this)->estado = qrecv(now.ctr2v[ Index(((P0 *)this)->id, 5) ], XX-1, 0, 0);
#ifdef VAR_RANGES
		logval("Vecino:estado", ((P0 *)this)->estado);
#endif
		;
		((P0 *)this)->i = qrecv(now.ctr2v[ Index(((P0 *)this)->id, 5) ], XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Vecino:i", ((P0 *)this)->i);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.ctr2v[ Index(((P0 *)this)->id, 5) ]);
		sprintf(simtmp, "%d", ((P0 *)this)->estado); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)this)->i); strcat(simvals, simtmp);		}
#endif
		if (q_zero(now.ctr2v[ Index(((P0 *)this)->id, 5) ]))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 13: // STATE 7 - hola.pml:28 - [((estado==sonando))] (0:0:1 - 1)
		IfNotBlocked
		reached[0][7] = 1;
		if (!((((P0 *)this)->estado==5)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: estado */  (trpt+1)->bup.oval = ((P0 *)this)->estado;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)this)->estado = 0;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 8 - hola.pml:28 - [ctr2v[id]!responde,i] (0:0:0 - 1)
		IfNotBlocked
		reached[0][8] = 1;
		if (q_len(now.ctr2v[ Index(((P0 *)this)->id, 5) ]))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.ctr2v[ Index(((P0 *)this)->id, 5) ]);
		sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)this)->i); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.ctr2v[ Index(((P0 *)this)->id, 5) ], 0, 1, ((P0 *)this)->i, 2);
		{ boq = now.ctr2v[ Index(((P0 *)this)->id, 5) ]; };
		_m = 2; goto P999; /* 0 */
	case 15: // STATE 9 - hola.pml:30 - [(1)] (13:0:0 - 1)
		IfNotBlocked
		reached[0][9] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(0, 11, 13) */
		reached[0][11] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 16: // STATE 13 - hola.pml:36 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][13] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

