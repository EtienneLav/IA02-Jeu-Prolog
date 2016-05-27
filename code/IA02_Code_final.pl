%prédicats généraux
reserve1([]).
reserve2([]).
bourse([[ble,7],[cacao,6],[cafe,6],[mais,6],[riz,6],[sucre,6]]).
joueur(0).
joueur2(1).

%-----------------------------------------Générer la position du trader au hasard -----------------------------------%
fGenTrader(X) :- random(1,10,X).

%---------------------------------------- Génération de la pile de marchandises -------------------------------------%
extraire([T|_], 0, T):-!.
extraire([_|Q], I, Res):-J is I-1, extraire(Q,J,Res).

test1(_):-mesMarchandises(X), affichageMarchandise(X), position(Y), affichagePosition(Y), !.

initMarchandisesDisponibles([ble, ble, ble, ble, ble, ble, cacao, cacao, cacao, cacao, cacao, cacao, riz, riz, riz, riz, riz, riz,
cafe, cafe, cafe, cafe, cafe, cafe, sucre, sucre, sucre, sucre, sucre, sucre, mais, mais, mais, mais, mais, mais]).

initMarchandises([P1,P2,P3,P4,P5,P6,P7,P8,P9]):-initMarchandisesDisponibles(R),initPile(R,P1,R2),
initPile(R2,P2,R3),
initPile(R3,P3,R4),
initPile(R4,P4,R5),
initPile(R5,P5,R6),
initPile(R6,P6,R7),
initPile(R7,P7,R8),
initPile(R8,P8,R9),
initPile(R9,P9,_).

initPile(Ressources,[J1,J2,J3,J4],NRessources):-length(Ressources, L), random(0, L, N1), extraire(Ressources, N1, J1), select(J1, Ressources, NRessources1),
length(NRessources1, L1), random(0, L1, N2), extraire(NRessources1, N2, J2), select(J2, NRessources1, NRessources2),
length(NRessources2, L2), random(0, L2, N3), extraire(NRessources2, N3, J3), select(J3, NRessources2, NRessources3),
length(NRessources3, L3), random(0, L3, N4), extraire(NRessources3, N4, J4), select(J4, NRessources3, NRessources).

%---------------------------------------------- Génération du plateau de départ ------------------------------------%						
%PLATEAU DEPART :
plateau_depart(Pile_march, Bourse, Trader, RJ1, RJ2):-write('------------------------------'), nl,
                                                       nl, write('Plateau de depart'), nl,
													   reserve1(RJ1), 
													   reserve2(RJ2), 
													   bourse(Bourse),
													   initMarchandises(Pile_march), fGenTrader(Trader).

%----------------------------------------------------------Divers -------------------------------------------------------%


%prédicat de concatenation ... servant à ajouter la ressource choisie dans la réserve du joueur
concat([], L, L).
concat([T|Q], L, [T|R]):-concat(Q, L, R).

%Renvoie Premier element d'une liste
first([H|_],H).

%Recupre la queue d'une liste sous forme de liste
queue([_|Q], Q).

%------------------------------------------------------ Affichages------------------------------------------------%	
%Prédicat servant à afficher où se situe le trader
afficher_pos(P,P):-write(' <- TRADER').
afficher_pos(_,_).

%Affiche le premier élément d'une liste et simplement le premier
afficher_premier([H|[]]):-write(H).
afficher_premier([H|_]):-write(H).

%Prédicat servant à afficher le contenu des piles de marchandises (premier élément + position du trader)
afficher_marchs([],_,_).
afficher_marchs([H|T],P,I):-write(I),write(': '),afficher_premier(H),afficher_pos(P,I), !, nl,J is I+1,afficher_marchs(T,P,J).


%Prédicat affichant le contenu d'une liste (utilisé dans l'affichage du contenu des réserve des joueurs)
afficher_liste([]).
afficher_liste([H|T]):-write(H), write(' '), afficher_liste(T).
													
%Prédicat Affichant le plateau
affiche_plateau(Pile_march, Bourse, Trader, RJ1, RJ2):-	write('------------------------------'), nl, nl,
													   write('Contenu des reserves '), nl, nl,  
													   write('Joueur 1 : { '),  afficher_liste(RJ1), write('}'),
													   nl,
													   write('Joueur 2 : { '),  afficher_liste(RJ2), write('}'),
													   nl,nl,
													   write('------------------------------'), nl,nl,	
													   write('Affichage de la bourse'), nl,nl,
													   write(Bourse), nl,nl,
													   write('------------------------------'), nl,nl,
													   write('Composition du plateau'),
													   nl, nl,
													   afficher_marchs(Pile_march, Trader, 1), nl.													
															%

   
%---------------------------------------------------------- Gestion -------------------------------------------------%

%Test validité du déplacement demandé par le joueur
testCoup(Deplacement):-repeat,
  write('De combien voulez-vous vous deplacer ? (1,2,3)'),nl,
  read(Deplacement),
  (Deplacement > 0, Deplacement <4).
 
%Choix marchandise à garder
garder_Marchandise(Choix1, Choix2, Choix_garder):-repeat,
     write('Quelle marchandise souhaitez vous garder ?'), nl,
     read(Choix_garder),
     (Choix_garder = Choix1;Choix_garder = Choix2).

%Recupère la marchandise jetée dans Jete
jeter_Marchandise(Choix1, Choix2, Garde, Choix2):- Choix1 = Garde,!.
jeter_Marchandise(Choix1, Choix2, Garde, Choix1):- !.  


%---------------------------------------------- Coup possible -------------------------------------------------------%
%pile de gauche de la nouvelle position du trader,
position_G(Newtrader, P_g, Pile_marc):- length(Pile_marc, Longueur), Newtrader =:= 1, P_g is Longueur, !.
position_G(Newtrader, P_g, Pile_marc):- P_g is Newtrader -1.

%pile de droite de la nouvelle position du trader,
position_D(Newtrader, P_d, Pile_marc):- length(Pile_marc, Longueur), Newtrader =:= Longueur, P_d is 1, !.
position_D(Newtrader, P_d, Pile_marc):- P_d is Newtrader +1.

%Prédicat COUP_POSSIBLE :
coup_possible(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur, Deplacement, Garde, Jete, NewTrader):- write('Joueur '), write(Joueur), write(' a votre tour'),nl,nl,
															testCoup(Deplacement),
															new_Pos_Trader(Trader, Deplacement, NewTrader, Pile_march),
															position_G(NewTrader, Pos_G, Pile_march),
															nth(Pos_G, Pile_march, PileG),
															position_D(NewTrader, Pos_D, Pile_march),
															nth(Pos_D, Pile_march, PileD),
															nl,
															write('Voici les marchandises jouables :'), nl,
															afficher_premier(PileG), nl, afficher_premier(PileD),
															nl, nl,
															first(PileG, Choix1),
															first(PileD, Choix2),
															garder_Marchandise(Choix1, Choix2, Garde),
															jeter_Marchandise(Choix1, Choix2, Garde, Jete), nl,
															write('Le '), write(Garde), write(' a ete ajoute dans votre reserve'),nl,
															write('Le '), write(Jete), write(' a ete jete... son cours baisse'), nl,nl.

															
%--------------------------------------------------- Mise à Jour des éléments du plateau -----------------------------%

%Mettre à jour la reserve du joueur 1
maj_reserve_joueur1(Joueur, Garde, OldReserve, OldReserve):- Joueur =:= 2, !.
maj_reserve_joueur1(Joueur, Garde, OldReserve, NewReserve):- concat([Garde], OldReserve, NewReserve),!.

%Mettre à jour la reserve du joueur 2
maj_reserve_joueur2(Joueur, Garde, OldReserve, OldReserve):- Joueur =:= 1,!.
maj_reserve_joueur2(Joueur, Garde, OldReserve, NewReserve):- concat([Garde], OldReserve, NewReserve),!.


%Met à jour l'élément Marchandise (baisse son cours de 1), dans la liste Bourse dans la nouvelle liste L1 actualisée (et ordonnée)
maj_Bourse(Marchandise, Bourse, L1):- select([Marchandise|X], Bourse, Unifie), first(X, Valeur), Valeur > 0, Valeur2 is Valeur -1, 
											append([[Marchandise, Valeur2]], Unifie, L), msort(L, L1), !.
maj_Bourse(Marchandise, Bourse, L1):- select([Marchandise|X], Bourse, Unifie), 
											append([[Marchandise, 0]], Unifie, L), msort(L, L1).											
										
%Met à jour les piles de marchandises (vire le premier élément de chaque pile utilisée) A APPELER DEUX FOIS...
maj_Piles(Pile_supp, Piles, L1, Numero):- select(Pile_supp, Piles, Unifie), queue(Pile_supp, Reste_pile), select(Reste_pile, L1, Unifie), nth(Numero, L1, Reste_pile).

%Position du trader modulo la longueur de la liste (éviter d'arriver à une position du trader à 10 ou 11 ou 12... lorsqu'il n'y a que 9 piles)
new_Pos_Trader(_, _, 1, Pile_march):- length(Pile_march, Longueur), Longueur = 1, !.
new_Pos_Trader(2, 3, 1, Pile_march):- length(Pile_march, Longueur), Longueur = 2, !.
new_Pos_Trader(2, 3, 1, Pile_march):- length(Pile_march, Longueur), Longueur = 2, !.
new_Pos_Trader(OldTrader, Deplacement, 1, Pile_march):- length(Pile_march, Longueur), Longueur=1,!.
new_Pos_Trader(OldTrader, Deplacement, NewTrader, Pile_march):- Test is (OldTrader + Deplacement), length(Pile_march, Longueur), Test < (Longueur +1), NewTrader is Test,!.
new_Pos_Trader(OldTrader, Deplacement, OldTrader, Pile_march):- length(Pile_march, Longueur), Longueur=Deplacement, OldTrader=Longueur, Deplacement = OldTrader,!.
new_Pos_Trader(OldTrader, Deplacement, 1, Pile_march):- length(Pile_march, Longueur), Longueur=1,!.
new_Pos_Trader(1, 3, 2, Pile_march):- length(Pile_march, Longueur), Longueur = 2, !.
%new_Pos_Trader(OldTrader, Deplacement, OldTrader, Pile_march):- length(Pile_march, Longueur), Test is (OldTrader + Deplacement), Test2 is (Longueur *2), Test2= Test, !.
new_Pos_Trader(OldTrader, Deplacement, NewTrader, Pile_march):- Test is (OldTrader + Deplacement), length(Pile_march, Longueur), NewTrader is Test mod Longueur.

new_Pos_Trader2(3, 3, 1, Pile_march):- length(Pile_march, Longueur), Longueur = 2, !.
new_Pos_Trader2(_, _, 1, Pile_march):- length(Pile_march, Longueur), Longueur = 1, !.
new_Pos_Trader2(2, 3, 1, Pile_march):- length(Pile_march, Longueur), Longueur = 2, !.
new_Pos_Trader2(OldTrader, Deplacement, NewTrader, Pile_march):- Test is (OldTrader + Deplacement), length(Pile_march, Longueur), Test =< Longueur, NewTrader is Test, !.
new_Pos_Trader2(OldTrader, Deplacement, NewTrader, Pile_march):- Test is (OldTrader + Deplacement), length(Pile_march, Longueur), Test > Longueur, OldTrader =< Longueur, NewTrader is (Test - Longueur),!.
new_Pos_Trader2(2, 3, 1, Pile_march):- length(Pile_march, Longueur), Longueur = 2, !.
new_Pos_Trader2(OldTrader, Deplacement, NewTrader, Pile_march):- Test is (OldTrader + Deplacement), length(Pile_march, Longueur), Test > Longueur, OldTrader > Longueur, Dec is (OldTrader -1), NewTrader is (Dec + Deplacement - Longueur),!.

%Prédicat servant à gérer le changement de joueur : passage du joueur 1 au joueur 2 et inversement
nouveauJoueur(Ancien, Nouveau):- Ancien<2, Nouveau is Ancien +1,!.
nouveauJoueur(Ancien, Nouveau):- Nouveau is Ancien -1,!.
%-----------------------------------------------Jouer Coup -----------------------------------------------------------%															
%Prédicat
supp_liste_vide([], []).
supp_liste_vide([[]|Q], N_Pile):- supp_liste_vide(Q, N_Pile), !.
supp_liste_vide([T|Q], N_Pile):-  supp_liste_vide(Q, N_Pile2), concat([T], N_Pile2, N_Pile).

%Décrémente trader si besoin est ...
pile_gauche_vide(Pile, OldTrader, NewTrader):- length(Pile, Longueur), Longueur =:= 1, OldTrader > 0, NewTrader is (OldTrader -1), !.
pile_gauche_vide(Pile, OldTrader, OldTrader).		

%Dcremente le trader si on est au bout de la liste des marchandises et que la première pile devient vide ...
pile_droit_au_bout(Pile, Pile_Droite, OldTrader, NewTrader):- length(Pile, Longueur_Pile),length(Pile_Droite, Longueur2), Longueur2 =:= 1, Longueur_Pile =:= OldTrader, NewTrader is (OldTrader -1), !.
pile_droit_au_bout(Pile, Pile_Droite, OldTrader, OldTrader).	

%Trader 0 :
trader_zero(Old, New):- Old =:= 0, New is 1, !.
trader_zero(Old, Old).	

%Trader dépasse le nomber d'élément dans la pile
trader_sup(Old, New, Pile):- length(Pile, Longueur), Old > Longueur, New is Longueur, !.
trader_sup(Old, Old, Pile).


%Prédicat JOUER_COUP :
jouer_coup(Pile_march, Bourse, NewTrader, RJ1, RJ2, Joueur, Deplacement, Garde, Jete, NewTrader5, NewPile_march2, NewBourse, NewReserveJ1, NewReserveJ2):-
															maj_reserve_joueur1(Joueur, Garde, RJ1, NewReserveJ1),
														    maj_reserve_joueur2(Joueur, Garde, RJ2, NewReserveJ2),
														     maj_Bourse(Jete, Bourse, NewBourse),
															position_G(NewTrader, Pos_G, Pile_march),
															nth(Pos_G, Pile_march, PileG),
															position_D(NewTrader, Pos_D, Pile_march),
															nth(Pos_D, Pile_march, PileD),
														    maj_Piles(PileG, Pile_march, L1, Pos_G),
														    maj_Piles(PileD, L1, NewPile_march, Pos_D), 													
															pile_gauche_vide(PileG, NewTrader, NewTrader2),
															pile_droit_au_bout(NewPile_march, PileD, NewTrader2, NewTrader3),
															trader_zero(NewTrader3, NewTrader4),
															supp_liste_vide(NewPile_march, NewPile_march2),
															trader_sup(NewTrader4, NewTrader5, NewPile_march2).
														

%---------------------------------------------------- Calcul du score ----------------------------------------------%
%Substitue la liste constituée des reserves d'un joueur par les valeurs des cours de chaque marchandises ...
%Exemple : RJ1([ble, mais, sucre]) deviendra après cette fonction : ValeurCours([2, 3, 1]) si la bourse est : Bourse([[ble, 3], [mais, 3], [sucre, 1]])
%Construit de manière récurrente la liste constituée des valeurs des cours de chaque marchandise présente dans la Reserve passée en premier paramètre.
%Ne conserve pas l'ordre mais on %s'en fiche... va servir à faire la somme ensuite....
liste_Cours([],_,[]):-!.
liste_Cours([T|Q], Bourse, Liste_sortie):- liste_Cours(Q, Bourse, Liste_sortie2), select([T|X], Bourse, _), concat(X, Liste_sortie2, Liste_sortie).

%Fais la somme des éléments de la liste des valeurs des cours des marchandises présent dans une réserve passée en paramètre
somme([],0).
somme([X|R],N) :- somme(R,N1), N is N1+X.

%Savoir qui gagne ? J1 ? J2 ou Egalité?
winner(ScoreJ1, ScoreJ2):- ScoreJ1 > ScoreJ2, nl, write('Le joueur 1 gagne avec '), write(ScoreJ1), write(' points !'), nl,nl, write('Le joueur 2 finit a '), write(ScoreJ2), write(' points...'),!.
winner(ScoreJ1, ScoreJ2):- ScoreJ2 > ScoreJ1, nl,nl, write('Le joueur 2 gagne avec '), write(ScoreJ2), write(' points !'), nl,nl, write('Le joueur 1 finit a '), write(ScoreJ1), write(' points...'),!.
winner(ScoreJ1, ScoreJ2):- ScoreJ2 =:= ScoreJ1, nl,nl, write('Egalite !!!!! --> '), write(ScoreJ1), write(' points').

%----------------------------------------------------Fin du jeu ---------------------------------------------------%

%Prédicat de FIN DU JEU
fin_jeu(Bourse, RJ1, RJ2):- nl,nl,nl,write('------------------------------'), nl, write('------------------------------'), nl,
						write('Le jeu est termine...'),
						nl,nl,
						write('Bourse a la fin du jeu : '), write(Bourse), 
						nl,
						write('Reserve joueur 1 a la fin du jeu : '), write(RJ1),
						nl,
						write('Reserve joueur 2 a la fin du jeu : '), write(RJ2),
						liste_Cours(RJ1, Bourse, CoursJ1), 
						liste_Cours(RJ2, Bourse, CoursJ2), 
						somme(CoursJ1, ScoreJ1), 
						somme(CoursJ2, ScoreJ2), 
						nl,nl,
						winner(ScoreJ1, ScoreJ2).

													   
 %-------------------------------------------------------Menu----------------------------------------------------------%		
%Vérifie que le choix est entre 1 et 4
lecture_choix(Choix):-repeat,
     read(Choix),
     (Choix >0;Choix <4).
	 
% lance la bonne option selon le choix du joueur,
choix_menu(1):- start2, !.
choix_menu(2):- start3, !.
choix_menu(3):- start4, !.
choix_menu(4):- nl,nl, write('A bientot...').

% Menu de choix du mode dde jeu	 
menu:-nl, write('Bievenue dans le Chicago Stock Exchange'),nl,nl,
	  write('1. Homme vs Homme'),nl,
	  write('2. Homme vs IA'), nl,
	  write('3. IA vs IA'), nl,
	  write('4. Quitter'),nl,nl,
	  lecture_choix(Choix),
	  choix_menu(Choix).

%-------------------------------------------------------Homme vs Homme ---------------------------------------------%
   
%Prédicat SUIVANT pour enchainer les coups,

suivant(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur_act):- length(Pile_march, Longueur_Pile),
												Longueur_Pile <3,
												fin_jeu(Bourse, RJ1, RJ2), !.
suivant(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur_act):-affiche_plateau(Pile_march, Bourse, Trader, RJ1, RJ2),
											   nouveauJoueur(Joueur_act, Joueur_suivant), 
											   coup_possible(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur_suivant, Deplacement, Garde, Jete, NewTrader),
											   jouer_coup(Pile_march, Bourse, NewTrader, RJ1, RJ2, Joueur_suivant, Deplacement, Garde, Jete, NewTrader2, NewPile_march, NewBourse, NewReserveJ1, NewReserveJ2),
											   suivant(NewPile_march, NewBourse, NewTrader2, NewReserveJ1, NewReserveJ2, Joueur_suivant).
  
%Lance le jeud Homme vs Homme	   
start2:-plateau_depart(Pile_march, Bourse, Trader, RJ1, RJ2),
		suivant(Pile_march, Bourse, Trader, RJ1, RJ2, 0).
	

%--------------------------------------------------------- Prédicats utiles à l'IA ----------------------------------------------------------%

%coups_possible([[mais],[sucre,cafe],[mais],[riz,mais]], [[ble,5],[cacao,2],[cafe,6],[mais,3],[riz,3],[sucre,3]], 3, [cacao, riz, cafe, ble, cafe, ble, cafe, cacao], [cafe, riz, ble, cafe, ble, ble, ble], 1, X).
%Prédicat coups_possibles, renvoie les différents coups possibles, 6 coups possibles à partir d'une position de trader, 3 déplacements fois 2 (choix de marchandise)
%Renvoie une liste composée de 6 sous listes constituées des 6 coups possibles

coups_possible(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur, [[1, March_G_1, March_J_1], [1, March_G_2, March_J_2], 
															  [2, March_G_3, March_J_3], [2, March_G_4, March_J_4], 
															  [3, March_G_5, March_J_5], [3, March_G_6, March_J_6]]):-
		
											new_Pos_Trader2(Trader, 1, NewTrader1, Pile_march),
											position_G(NewTrader1, Pos_G1, Pile_march),
											nth(Pos_G1, Pile_march, PileG1),
											position_D(NewTrader1, Pos_D1, Pile_march),
											nth(Pos_D1, Pile_march, PileD1),
											first(PileG1, March_G_1),
											first(PileD1, March_J_1),
											first(PileD1, March_G_2),
											first(PileG1, March_J_2),
											
											
											new_Pos_Trader2(Trader, 2, NewTrader2, Pile_march),
											position_G(NewTrader2, Pos_G2, Pile_march),
											nth(Pos_G2, Pile_march, PileG2),
											position_D(NewTrader2, Pos_D2, Pile_march),
											nth(Pos_D2, Pile_march, PileD2),
											first(PileG2, March_G_3),
											first(PileD2, March_J_3),
											first(PileD2, March_G_4),
											first(PileG2, March_J_4),
											
											
											new_Pos_Trader2(Trader, 3, NewTrader3, Pile_march),											
											position_G(NewTrader3, Pos_G3, Pile_march),
											nth(Pos_G3, Pile_march, PileG3),
											position_D(NewTrader3, Pos_D3, Pile_march),
											nth(Pos_D3, Pile_march, PileD3),
											first(PileG3, March_G_5),
											first(PileD3, March_J_5),
											first(PileD3, March_G_6),
											first(PileG3, March_J_6).
											
%Prédicat de test des coups possibles
testIA:-coups_possible([[sucre,cafe,cacao,sucre], [mais,riz,riz,mais], [ble,mais,cafe,ble], [riz,cacao,sucre,cafe], [cafe,ble,mais,ble], [ble,sucre,cacao,mais],  [cacao,riz,cacao,sucre],  [sucre,cafe,riz,cafe], [cacao,ble,riz,mais]], [[ble,7],[cacao,6],[cafe,6],[mais,6],[riz,6],[sucre,6]], 3, [], [], 1, X), write(X).

%Prédicat Minimum entre nombres (vérifié et testé, ça marche) :
minimum_elements(ScoreJ1, ScoreJ2, ScoreJ3, ScoreJ4, ScoreJ5, ScoreJ6, Min):-     Min1 is min(ScoreJ1, ScoreJ2),
																			   Min2 is min(ScoreJ3, Min1),
																			   Min3 is min(ScoreJ4, Min2),
																			   Min is min(ScoreJ5, Min3).

%Prédicat Max entre nombres (vérifié et testé, ça marche) :
maximum_elements(ScoreJ1, ScoreJ2, ScoreJ3, ScoreJ4, ScoreJ5, ScoreJ6, Max):-     Max1 is max(ScoreJ1, ScoreJ2),
																			   Max2 is max(ScoreJ3, Max1),
																			   Max3 is max(ScoreJ4, Max2),
																			   Max4 is max(ScoreJ5, Max3),
																			   Max is max(ScoreJ6, Max4).																			   Min is min(ScoreJ6, Min4).

																			   
%Unifie les valeurs de retours si le score correspond au max (testé individuellement --> marche et unifie ss Score = Max, rien sinon):
test_bon_coup(Score, Max, D, Garde, Jete, NewTrader, D, Garde, Jete, NewTrader):- Score= Max, !.
test_bon_coup(Score, Max, D, Garde1, Jete1, NewTrader1, Deplacement, Garde, Jete, NewTrader).

%Prédicat renvoie le minimum des coups possibles
%6 premiers récupère les 6 cas possibles
%6 secondes récupère les marchandises gardées à chaque "sous coup"
%6 tierces récupère les marchandises jetées à chaque "sous coup"
%6 quartes MAJ bourse selon chaque sous coup joué
%6 quinte MAJ RJ1 pour chaque sous coup joué
%6 sixtes calcule score pour chaque sous coup puis calcul minimum de ces coups et le renvoie en Score11

%Test individuellement grâce --> %minimum([[ble,2],[cacao,5],[cafe,6],[mais,6],[riz,6],[sucre,6]], [sucre], [mais], [[1,ble,mais],[1,mais,ble],[2,cafe,sucre],[2,sucre,cafe],[3,mais,ble],[3,ble,mais]], Min). qui renvoie 2
% Prédicat qui va renvoyer les differents scores possibles
%Quand le joueur1 est en train de jouer, à la profondeur 2, rien  à faire .. si ce n'est modifier la bourse et calculer son score pour chaque possibilite...
joueur_IA(1, NewBourse, NewReserveJ1, NewReserveJ2, Coups_possibleProf, ScoreJ1, ScoreJ2, ScoreJ3, ScoreJ4, ScoreJ5, ScoreJ6):-
																	 nth(1, Coups_possibleProf, Coup_possible1),
																	 nth(2, Coups_possibleProf, Coup_possible2),
																	 nth(3, Coups_possibleProf, Coup_possible3),
																	 nth(4, Coups_possibleProf, Coup_possible4),
																	 nth(5, Coups_possibleProf, Coup_possible5),
																	 nth(6, Coups_possibleProf, Coup_possible6),
																	 
																	 nth(2, Coup_possible1, Garde1),
																	 nth(2, Coup_possible2, Garde2),
																	 nth(2, Coup_possible3, Garde3),
																	 nth(2, Coup_possible4, Garde4),
																	 nth(2, Coup_possible5, Garde5),
																	 nth(2, Coup_possible6, Garde6),
																	 
																	 nth(3, Coup_possible1, Jete1),
																	 nth(3, Coup_possible2, Jete2),
																	 nth(3, Coup_possible3, Jete3),
																	 nth(3, Coup_possible4, Jete4),
																	 nth(3, Coup_possible5, Jete5),
																	 nth(3, Coup_possible6, Jete6),
																	 
																	 maj_Bourse(Jete1, NewBourse, NewBourse1),
																	 maj_Bourse(Jete2, NewBourse, NewBourse2),
																	 maj_Bourse(Jete3, NewBourse, NewBourse3),
																	 maj_Bourse(Jete4, NewBourse, NewBourse4),
																	 maj_Bourse(Jete5, NewBourse, NewBourse5),
																	 maj_Bourse(Jete6, NewBourse, NewBourse6),
																	 
																	 
																	 liste_Cours(NewReserveJ1, NewBourse1, CoursJ1), 
																	 somme(CoursJ1, ScoreJ1),
																	 
																	 liste_Cours(NewReserveJ1, NewBourse2, CoursJ2), 
																	 somme(CoursJ2, ScoreJ2), 
																	 
																	 liste_Cours(NewReserveJ1, NewBourse3, CoursJ3), 
																	 somme(CoursJ3, ScoreJ3), 
																	 
																	 liste_Cours(NewReserveJ1, NewBourse4, CoursJ4), 
																	 somme(CoursJ4, ScoreJ4), 
																	 
																	 liste_Cours(NewReserveJ1, NewBourse5, CoursJ5), 
																	 somme(CoursJ5, ScoreJ5), 
																	 
																	 liste_Cours(NewReserveJ1, NewBourse6, CoursJ6), 
																	 somme(CoursJ6, ScoreJ6).

%Quand le joueur deux est en train de jouer... A la profondeur 2 ...Ce sera au joueur 1 de jouer, il va modifier sa liste de ressource... Donc sa réserve, 
joueur_IA(2, NewBourse, NewReserveJ1, NewReserveJ2, Coups_possibleProf, ScoreJ1, ScoreJ2, ScoreJ3, ScoreJ4, ScoreJ5, ScoreJ6):-
																	 nth(1, Coups_possibleProf, Coup_possible1),
																	 nth(2, Coups_possibleProf, Coup_possible2),
																	 nth(3, Coups_possibleProf, Coup_possible3),
																	 nth(4, Coups_possibleProf, Coup_possible4),
																	 nth(5, Coups_possibleProf, Coup_possible5),
																	 nth(6, Coups_possibleProf, Coup_possible6),
																	 
																	 nth(2, Coup_possible1, Garde1),
																	 nth(2, Coup_possible2, Garde2),
																	 nth(2, Coup_possible3, Garde3),
																	 nth(2, Coup_possible4, Garde4),
																	 nth(2, Coup_possible5, Garde5),
																	 nth(2, Coup_possible6, Garde6),
																	 
																	 nth(3, Coup_possible1, Jete1),
																	 nth(3, Coup_possible2, Jete2),
																	 nth(3, Coup_possible3, Jete3),
																	 nth(3, Coup_possible4, Jete4),
																	 nth(3, Coup_possible5, Jete5),
																	 nth(3, Coup_possible6, Jete6),
																	 
																	 maj_Bourse(Jete1, NewBourse, NewBourse1),
																	 maj_Bourse(Jete2, NewBourse, NewBourse2),
																	 maj_Bourse(Jete3, NewBourse, NewBourse3),
																	 maj_Bourse(Jete4, NewBourse, NewBourse4),
																	 maj_Bourse(Jete5, NewBourse, NewBourse5),
																	 maj_Bourse(Jete6, NewBourse, NewBourse6),
																	 
																	 maj_reserve_joueur1(1, Garde1, NewReserveJ1, Nouvelle_Reserve1),
																	 maj_reserve_joueur1(1, Garde2, NewReserveJ1, Nouvelle_Reserve2),
																	 maj_reserve_joueur1(1, Garde3, NewReserveJ1, Nouvelle_Reserve3),
																	 maj_reserve_joueur1(1, Garde4, NewReserveJ1, Nouvelle_Reserve4),
																	 maj_reserve_joueur1(1, Garde5, NewReserveJ1, Nouvelle_Reserve5),
																	 maj_reserve_joueur1(1, Garde6, NewReserveJ1, Nouvelle_Reserve6),
																	 
																	 liste_Cours(Nouvelle_Reserve1, NewBourse1, CoursJ1), 
																	 somme(CoursJ1, ScoreJ1),
																	 
																	 liste_Cours(Nouvelle_Reserve2, NewBourse2, CoursJ2), 
																	 somme(CoursJ2, ScoreJ2), 
																	 
																	 liste_Cours(Nouvelle_Reserve3, NewBourse3, CoursJ3), 
																	 somme(CoursJ3, ScoreJ3), 
																	 
																	 liste_Cours(Nouvelle_Reserve4, NewBourse4, CoursJ4), 
																	 somme(CoursJ4, ScoreJ4), 
																	 
																	 liste_Cours(Nouvelle_Reserve5, NewBourse5, CoursJ5), 
																	 somme(CoursJ5, ScoreJ5), 
																	 
																	 liste_Cours(Nouvelle_Reserve6, NewBourse6, CoursJ6), 
																	 somme(CoursJ6, ScoreJ6).
																	 
																	 
%Prédicat selection meilleur coup possible,
%A chaque fois : récupère liste des coups possible selon la position actuelle
%A chaque fois récupère le déplacement en question de ce groupe de coup
%MAJ Trader, Recupère marchandises gardée, jetée.
%Joue le coup en question, pour avoir nouveau plateau (sorte de simulation de coup)
%Puis calcul les 6 "sous coups" de chaque coups et les envoie dans minimu pour se faire calculer le minimum
%Enfin une fois les 6 minimum trouvé.. Trouve le Max de ces min... Puis unifie et renvoie le déplacement de ce coup le meilleur dans Deplacement ...
%meilleur_coup_possible([[mais],[sucre,cafe],[mais],[riz,mais]], [[ble,5],[cacao,2],[cafe,6],[mais,3],[riz,3],[sucre,3]], 3, [cacao, riz, cafe, ble, cafe, ble, cafe, cacao], [cafe, riz, ble, cafe, ble, ble, ble], 1, Dep, Gar, Je, New).

%Quand le joueur 1 joue... il faut jouer le coup suivant et celui a la profondeur 2 est passif ... (appel de "joueur_IA" avec le premier paramètre = 1)
meilleur_coup_possible(Pile_march, Bourse, Trader, ReserveJ1, ReserveJ2, 1 , Deplacement, Garde, Jete, NewTrader):-
					
					coups_possible(Pile_march, Bourse, Trader, ReserveJ1, ReserveJ2, 1, Coups_possibleProf),
					
					first(Coups_possibleProf, Config1),
					first(Config1, Trader1),
					new_Pos_Trader(Trader1, 1, NewTrader1, Pile_march),
					nth(2, Config1, Garde1), 
					nth(3, Config1, Jete1), 
					jouer_coup(Pile_march, Bourse, NewTrader1, ReserveJ1, ReserveJ2, 1, 1, Garde1, Jete1, NewTrader11, NewPile_march1, NewBourse1, NewReserveJ11, NewReserveJ21),
					coups_possible(NewPile_march1, NewBourse1, NewTrader11, NewReserveJ11, NewReserveJ21, 2, Coups_possibleProf11),
					joueur_IA(1, NewBourse1, NewReserveJ11, NewReserveJ21, Coups_possibleProf11, Score_Int11, Score_Int12,Score_Int13, Score_Int14, Score_Int15, Score_Int16),
					minimum_elements(Score_Int11, Score_Int12, Score_Int13, Score_Int14, Score_Int15, Score_Int16, Min1),
					
			
					nth(2, Coups_possibleProf, Config2),
					first(Config2, Trader2),
					new_Pos_Trader(Trader2, 1, NewTrader2, Pile_march),
					nth(2, Config2, Garde2), 
					nth(3, Config2, Jete2), 
					jouer_coup(Pile_march, Bourse, NewTrader2, ReserveJ1, ReserveJ2, 1, 1, Garde2, Jete2, NewTrader22, NewPile_march2, NewBourse2, NewReserveJ12, NewReserveJ22),
					coups_possible(NewPile_march2, NewBourse2, NewTrader22, NewReserveJ12, NewReserveJ22, 2, Coups_possibleProf21),
					joueur_IA(1, NewBourse2, NewReserveJ12, NewReserveJ22, Coups_possibleProf21, Score_Int21, Score_Int22,Score_Int23, Score_Int24, Score_Int25, Score_Int26),
					minimum_elements(Score_Int21, Score_Int22, Score_Int23, Score_Int24, Score_Int25, Score_Int26, Min2),
					
					
					nth(3, Coups_possibleProf, Config3),
					first(Config3, Trader3),
					new_Pos_Trader(Trader3, 2, NewTrader3, Pile_march),
					nth(2, Config3, Garde3), 
					nth(3, Config3, Jete3), 
					jouer_coup(Pile_march, Bourse, NewTrader3, ReserveJ1, ReserveJ2, 1, 2, Garde3, Jete3, NewTrader33, NewPile_march3, NewBourse3, NewReserveJ13, NewReserveJ23),
					coups_possible(NewPile_march3, NewBourse3, NewTrader33, NewReserveJ13, NewReserveJ23, 2, Coups_possibleProf31),
					joueur_IA(1, NewBourse3, NewReserveJ13, NewReserveJ23, Coups_possibleProf31, Score_Int31, Score_Int32,Score_Int33, Score_Int34, Score_Int35, Score_Int36),
					minimum_elements(Score_Int31, Score_Int32, Score_Int33, Score_Int34, Score_Int35, Score_Int36, Min3),
				
				
					nth(4, Coups_possibleProf, Config4),
					first(Config4, Trader4),
					new_Pos_Trader(Trader4, 2, NewTrader4, Pile_march),
					nth(2, Config4, Garde4), 
					nth(3, Config4, Jete4), 
					jouer_coup(Pile_march, Bourse, NewTrader4, ReserveJ1, ReserveJ2, 1, 2, Garde4, Jete4, NewTrader44, NewPile_march4, NewBourse4, NewReserveJ14, NewReserveJ24),
					coups_possible(NewPile_march4, NewBourse4, NewTrader44, NewReserveJ14, NewReserveJ24, 2, Coups_possibleProf41),
					joueur_IA(1, NewBourse4, NewReserveJ14, NewReserveJ24, Coups_possibleProf41, Score_Int41, Score_Int42,Score_Int43, Score_Int44, Score_Int45, Score_Int46),
					minimum_elements(Score_Int41, Score_Int42, Score_Int43, Score_Int44, Score_Int45, Score_Int46, Min4),
				
				
					nth(5, Coups_possibleProf, Config5),
					first(Config5, Trader5),
					new_Pos_Trader(Trader5, 3, NewTrader5, Pile_march),
					nth(2, Config5, Garde5), 
					nth(3, Config5, Jete5), 
					jouer_coup(Pile_march, Bourse, NewTrader5, ReserveJ1, ReserveJ2, 1, 3, Garde5, Jete5, NewTrader55, NewPile_march5, NewBourse5, NewReserveJ15, NewReserveJ25),
					coups_possible(NewPile_march5, NewBourse5, NewTrader55, NewReserveJ15, NewReserveJ25, 2, Coups_possibleProf51),
					joueur_IA(1, NewBourse5, NewReserveJ15, NewReserveJ25, Coups_possibleProf51, Score_Int51, Score_Int52,Score_Int53, Score_Int54, Score_Int55, Score_Int56),
					minimum_elements(Score_Int51, Score_Int52, Score_Int53, Score_Int54, Score_Int55, Score_Int56, Min5),
					
					
					nth(6, Coups_possibleProf, Config6),
					first(Config6, Trader6),
					new_Pos_Trader(Trader6, 3, NewTrader6, Pile_march),
					nth(2, Config6, Garde6), 
					nth(3, Config6, Jete6), 
					jouer_coup(Pile_march, Bourse, NewTrader6, ReserveJ1, ReserveJ2, 1, 3, Garde6, Jete6, NewTrader66, NewPile_march6, NewBourse6, NewReserveJ16, NewReserveJ26),
					coups_possible(NewPile_march6, NewBourse6, NewTrader66, NewReserveJ16, NewReserveJ26, 2, Coups_possibleProf61),	
					joueur_IA(1, NewBourse6, NewReserveJ16, NewReserveJ26, Coups_possibleProf61, Score_Int61, Score_Int62,Score_Int63, Score_Int64, Score_Int65, Score_Int66),
					minimum_elements(Score_Int61, Score_Int62, Score_Int63, Score_Int64, Score_Int65, Score_Int66, Min6),

					maximum_elements(Min1, Min2, Min3, Min4, Min5, Min6, Max),
					
					test_bon_coup(Min1, Max, 1, Garde1, Jete1, NewTrader1, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Min2, Max, 1, Garde2, Jete2, NewTrader2, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Min3, Max, 2, Garde3, Jete3, NewTrader3, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Min4, Max, 2, Garde4, Jete4, NewTrader4, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Min5, Max, 3, Garde5, Jete5, NewTrader5, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Min6, Max, 3, Garde6, Jete6, NewTrader6, Deplacement, Garde, Jete, NewTrader).

					
%Quand le joueur2 joue ... Alors il doit jouer le coup suivant, mais celui a la profondeur 2 doit être actif ... en effet le joueur1 jouera à la profondeur 2.. Donc appeler le bon "joueur_IA"
meilleur_coup_possible(Pile_march, Bourse, Trader, ReserveJ1, ReserveJ2, 2 , Deplacement, Garde, Jete, NewTrader):-
					
					coups_possible(Pile_march, Bourse, Trader, ReserveJ1, ReserveJ2, 2, Coups_possibleProf),
					
					first(Coups_possibleProf, Config1),
					first(Config1, Trader1),
					new_Pos_Trader(Trader1, 1, NewTrader1, Pile_march),
					nth(2, Config1, Garde1), 
					nth(3, Config1, Jete1), 
					jouer_coup(Pile_march, Bourse, NewTrader1, ReserveJ1, ReserveJ2, 2, 1, Garde1, Jete1, NewTrader11, NewPile_march1, NewBourse1, NewReserveJ11, NewReserveJ21),
					coups_possible(NewPile_march1, NewBourse1, NewTrader11, NewReserveJ11, NewReserveJ21, 2, Coups_possibleProf11),
					joueur_IA(2, NewBourse1, NewReserveJ11, NewReserveJ21, Coups_possibleProf11, Score_Int11, Score_Int12,Score_Int13, Score_Int14, Score_Int15, Score_Int16),
					maximum_elements(Score_Int11, Score_Int12, Score_Int13, Score_Int14, Score_Int15, Score_Int16, Max1),
					
			
					nth(2, Coups_possibleProf, Config2),
					first(Config2, Trader2),
					new_Pos_Trader(Trader2, 1, NewTrader2, Pile_march),
					nth(2, Config2, Garde2), 
					nth(3, Config2, Jete2), 
					jouer_coup(Pile_march, Bourse, NewTrader2, ReserveJ1, ReserveJ2, 2, 1, Garde2, Jete2, NewTrader22, NewPile_march2, NewBourse2, NewReserveJ12, NewReserveJ22),
					coups_possible(NewPile_march2, NewBourse2, NewTrader22, NewReserveJ12, NewReserveJ22, 2, Coups_possibleProf21),
					joueur_IA(2, NewBourse2, NewReserveJ12, NewReserveJ22, Coups_possibleProf21, Score_Int21, Score_Int22,Score_Int23, Score_Int24, Score_Int25, Score_Int26),
					maximum_elements(Score_Int21, Score_Int22, Score_Int23, Score_Int24, Score_Int25, Score_Int26, Max2),
					
					
					nth(3, Coups_possibleProf, Config3),
					first(Config3, Trader3),
					new_Pos_Trader(Trader3, 2, NewTrader3, Pile_march),
					nth(2, Config3, Garde3), 
					nth(3, Config3, Jete3), 
					jouer_coup(Pile_march, Bourse, NewTrader3, ReserveJ1, ReserveJ2, 2, 2, Garde3, Jete3, NewTrader33, NewPile_march3, NewBourse3, NewReserveJ13, NewReserveJ23),
					coups_possible(NewPile_march3, NewBourse3, NewTrader33, NewReserveJ13, NewReserveJ23, 2, Coups_possibleProf31),
					joueur_IA(2, NewBourse3, NewReserveJ13, NewReserveJ23, Coups_possibleProf31, Score_Int31, Score_Int32,Score_Int33, Score_Int34, Score_Int35, Score_Int36),
					maximum_elements(Score_Int31, Score_Int32, Score_Int33, Score_Int34, Score_Int35, Score_Int36, Max3),
				
					nth(4, Coups_possibleProf, Config4),
					first(Config4, Trader4),
					new_Pos_Trader(Trader4, 2, NewTrader4, Pile_march),
					nth(2, Config4, Garde4), 
					nth(3, Config4, Jete4), 
					jouer_coup(Pile_march, Bourse, NewTrader4, ReserveJ1, ReserveJ2, 2, 2, Garde4, Jete4, NewTrader44, NewPile_march4, NewBourse4, NewReserveJ14, NewReserveJ24),
					coups_possible(NewPile_march4, NewBourse4, NewTrader44, NewReserveJ14, NewReserveJ24, 2, Coups_possibleProf41),
					joueur_IA(2, NewBourse4, NewReserveJ14, NewReserveJ24, Coups_possibleProf41, Score_Int41, Score_Int42,Score_Int43, Score_Int44, Score_Int45, Score_Int46),
					maximum_elements(Score_Int41, Score_Int42, Score_Int43, Score_Int44, Score_Int45, Score_Int46, Max4),
				
					nth(5, Coups_possibleProf, Config5),
					first(Config5, Trader5),
					new_Pos_Trader(Trader5, 3, NewTrader5, Pile_march),
					nth(2, Config5, Garde5), 
					nth(3, Config5, Jete5), 
					jouer_coup(Pile_march, Bourse, NewTrader5, ReserveJ1, ReserveJ2, 2, 3, Garde5, Jete5, NewTrader55, NewPile_march5, NewBourse5, NewReserveJ15, NewReserveJ25),
					coups_possible(NewPile_march5, NewBourse5, NewTrader55, NewReserveJ15, NewReserveJ25, 2, Coups_possibleProf51),
					joueur_IA(2, NewBourse5, NewReserveJ15, NewReserveJ25, Coups_possibleProf51, Score_Int51, Score_Int52,Score_Int53, Score_Int54, Score_Int55, Score_Int56),
					maximum_elements(Score_Int51, Score_Int52, Score_Int53, Score_Int54, Score_Int55, Score_Int56, Max5),
					
					nth(6, Coups_possibleProf, Config6),
					first(Config6, Trader6),
					new_Pos_Trader(Trader6, 3, NewTrader6, Pile_march),
					nth(2, Config6, Garde6), 
					nth(3, Config6, Jete6), 
					jouer_coup(Pile_march, Bourse, NewTrader6, ReserveJ1, ReserveJ2, 2, 3, Garde6, Jete6, NewTrader66, NewPile_march6, NewBourse6, NewReserveJ16, NewReserveJ26),
					coups_possible(NewPile_march6, NewBourse6, NewTrader66, NewReserveJ16, NewReserveJ26, 2, Coups_possibleProf61),	
					joueur_IA(2, NewBourse6, NewReserveJ16, NewReserveJ26, Coups_possibleProf61, Score_Int61, Score_Int62,Score_Int63, Score_Int64, Score_Int65, Score_Int66),
					maximum_elements(Score_Int61, Score_Int62, Score_Int63, Score_Int64, Score_Int65, Score_Int66, Max6),
					
					minimum_elements(Max1, Max2, Max3, Max4, Max5, Max6, Min),
					
					test_bon_coup(Max1, Min, 1, Garde1, Jete1, NewTrader1, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Max2, Min, 1, Garde2, Jete2, NewTrader2, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Max3, Min, 2, Garde3, Jete3, NewTrader3, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Max4, Min, 2, Garde4, Jete4, NewTrader4, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Max5, Min, 3, Garde5, Jete5, NewTrader5, Deplacement, Garde, Jete, NewTrader),
					test_bon_coup(Max6, Min, 3, Garde6, Jete6, NewTrader6, Deplacement, Garde, Jete, NewTrader).
%------------------------------------------------- IA vs IA -----------------------------------------------------------------
%Prédicat testant si la fin du jeu est possible entre les deux coups joués dans suivant ... "if"
next_test_ia_ia(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 1):- length(NewPile_march, Longueur_Pile), Longueur_Pile <3, suivant_IA(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 1),!.
next_test_ia_ia(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 1):- meilleur_coup_possible(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 2, Deplacement2, Garde2, Jete2, NewTrader6),
											   new_Pos_Trader(NewTrader3, Deplacement2, NewTrader4, NewPile_march),
											   jouer_coup(NewPile_march, NewBourse, NewTrader4, NewReserveJ1, NewReserveJ2, 2, Deplacement2, Garde2, Jete2, NewTrader_ret, NewPile_march_ret, NewBourse_ret, NewReserveJ1_ret, NewReserveJ2_ret),
											   suivant_IA(NewPile_march_ret, NewBourse_ret, NewTrader_ret, NewReserveJ1_ret, NewReserveJ2_ret, 2).

%prédicat pour enchainer les coups IA vs IA
suivant_IA(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur_act):- 
												length(Pile_march, Longueur_Pile),
												Longueur_Pile <3,
												fin_jeu(Bourse, RJ1, RJ2), !.
suivant_IA(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur_act):-
											   affiche_plateau(Pile_march, Bourse, Trader, RJ1, RJ2), 
											   write(Pile_march), nl,nl,
											 
											   meilleur_coup_possible(Pile_march, Bourse, Trader, ReserveJ1, ReserveJ2, 1, Deplacement1, Garde1, Jete1, NewTrader1),
											   new_Pos_Trader(Trader, Deplacement1, NewTrader2, Pile_march),
											   
											   jouer_coup(Pile_march, Bourse, NewTrader2, RJ1, RJ2, 1, Deplacement1, Garde1, Jete1, NewTrader3, NewPile_march, NewBourse, NewReserveJ1, NewReserveJ2),
											   write(Garde1),nl, nl,write(Jete1),nl,nl,
											   affiche_plateau(NewPile_march, NewBourse,NewTrader3, NewReserveJ1, NewReserveJ2),
											   
											   next_test_ia_ia(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 1).

%Prédicat pour lancer IA VS IA
start4:-plateau_depart(Pile_march, Bourse, Trader, RJ1, RJ2),
		suivant_IA(Pile_march, Bourse, Trader, RJ1, RJ2, 0).
			
%TestProblématique :
meilleur_coup_possible([[cacao,ble],[sucre],[cafe,riz,mais]], [[ble,1],[cacao,4],[cafe,2],[mais,6],[riz,6],[sucre,3]], 3, [mais, riz, mais, riz, mais, sucre, ble, ble], [riz, cafe, riz, mais, ble, riz, mais], 2, Dep, Garde, Jete, NewT).
meilleur_coup_possible([[riz],[mais],[riz],[cacao]], [[ble,2],[cacao,6],[cafe,5],[mais,1],[riz,2],[sucre,5]], 3, [sucre, sucre, cacao, cafe, cacao, cafe, cacao, ble], [sucre, cafe, sucre, cacao, cafe, cacao, sucre, ble], 2, Dep, Garde, Jete, NewT).
meilleur_coup_possible([[ble],[sucre],[riz,mais]], [[ble,1],[cacao,4],[cafe,1],[mais,6],[riz,6],[sucre,3]], 2, [mais, riz, mais, riz, mais, sucre, ble, ble], [cacao, riz, cafe, riz, mais, ble, riz, mais], 2, Dep, Garde, Jete, NewT).


%----------------------------------------------------- Homme vs IA ---------------------------------------------------------------------------------%

% Prédicat pour vérifier la fin du jeu entre les deux coups joués dans "suivant", une sorte de "if"
next_test_ia_homme(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 1):- length(NewPile_march, Longueur_Pile), Longueur_Pile <3, suivant_Homme_IA(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 1),!.
next_test_ia_homme(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 1):- meilleur_coup_possible(NewPile_march, NewBourse, NewTrader3, NewReserveJ1, NewReserveJ2, 2, Deplacement2, Garde2, Jete2, NewTraderINUTILE),
											   new_Pos_Trader(NewTrader3, Deplacement2, NewTrader4, NewPile_march),
											   jouer_coup(NewPile_march, NewBourse, NewTrader4, NewReserveJ1, NewReserveJ2, 2, Deplacement2, Garde2, Jete2, N_NewTrader, N_NewPile_march, N_NewBourse, N_NewReserveJ1, N_NewReserveJ2),
											   write(Garde2),nl,nl,write(Jete2),nl,nl,
											   write(NewPile_march),nl,nl,
											   nl,nl,write(NewTrader3),nl,nl,
											   suivant_Homme_IA(N_NewPile_march, N_NewBourse, N_NewTrader, N_NewReserveJ1, N_NewReserveJ2, 2).

%Prédicat pour enchainer les coups entre l'Homme et l'IA
suivant_Homme_IA(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur_act):- 
												length(Pile_march, Longueur_Pile),
												Longueur_Pile <3,
												fin_jeu(Bourse, RJ1, RJ2), !.
suivant_Homme_IA(Pile_march, Bourse, Trader, RJ1, RJ2, Joueur_act):-
											   affiche_plateau(Pile_march, Bourse, Trader, RJ1, RJ2), 
											   write(Pile_march), nl,nl,
											   coup_possible(Pile_march, Bourse, Trader, RJ1, RJ2, 1, Deplacement, Garde, Jete, NewTrader),
											   jouer_coup(Pile_march, Bourse, NewTrader, RJ1, RJ2, 1, Deplacement, Garde, Jete, NewTrader2, NewPile_march, NewBourse, NewReserveJ1, NewReserveJ2),
											   
											   affiche_plateau(NewPile_march, NewBourse, NewTrader2, NewReserveJ1, NewReserveJ2), 
											   
											   next_test_ia_homme(NewPile_march, NewBourse, NewTrader2, NewReserveJ1, NewReserveJ2, 1).
											   

%Prédicat pour lancer Homme VS IA :
start3:-plateau_depart(Pile_march, Bourse, Trader, RJ1, RJ2),
		suivant_Homme_IA(Pile_march, Bourse, Trader, RJ1, RJ2, 0).