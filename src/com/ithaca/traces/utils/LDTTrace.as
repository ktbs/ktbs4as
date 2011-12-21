package com.ithaca.traces.utils
{
	import com.ithaca.traces.Attribute;
	import com.ithaca.traces.AttributeType;
	import com.ithaca.traces.Base;
	import com.ithaca.traces.Ktbs;
	import com.ithaca.traces.Model;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.ObselType;
	import com.ithaca.traces.Relation;
	import com.ithaca.traces.RelationType;
	import com.ithaca.traces.Resource;
	import com.ithaca.traces.StoredTrace;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class LDTTrace extends EventDispatcher
	{
		/**
		 * Defines the Singleton instance of the Trace
		 */
		public static var mainKtbs:Ktbs;
		public static var mainBase:Base;
		public static var mainTrace:StoredTrace;
		public static var mainModel:Model;
		public static var modelStrict:Boolean = false; // questionnable au moment du recueil, ca serait plus à faire au niveau de l'utilisation de la trace a posteriori
		
		public function LDTTrace()
		{
			super();
		}
		
		/**
		 * Convenience static method to quickly create an Obsel and
		 * add it to the trace (singleton).
		 */
		
		public static function initLDTModel():void
		{
			if(mainBase)
			{
				
				LDTTrace.mainModel = LDTTrace.mainBase.createModel("LDTModel2010");
			
			
			
			LDTTrace.mainModel.createObselType("repositionnementPlayer");
			//attribute : idPlayer (optionnal : false)
			
			LDTTrace.mainModel.createObselType("changementPositionPlayer");
			//attribute : newX (optionnal : false)
			//attribute : newHeight (optionnal : false)
			//attribute : newY (optionnal : false)
			//attribute : idPlayer (optionnal : false)
			//attribute : newWidth (optionnal : false)
			//attribute : obselCause (optionnal : false)
			
			LDTTrace.mainModel.createObselType("ouvertureProjet");
			//attribute : nomUtilisateur (optionnal : false)
			//attribute : idProjet (optionnal : false)
			//attribute : titre (optionnal : false)
			//attribute : description (optionnal : false)
			
			LDTTrace.mainModel.createObselType("selectionBAB");
			//attribute : idBab (optionnal : false)
			//attribute : titre (optionnal : false)
			//attribute : resume (optionnal : false)
			
			LDTTrace.mainModel.createObselType("affichageVue");
			//attribute : idVue (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modificationZoom");
			//attribute : zoom (optionnal : false)
			
			LDTTrace.mainModel.createObselType("affichageMedia");
			//attribute : index (optionnal : false)
			//attribute : titreMedia (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("affichageDecoupage");
			//attribute : titreMedia (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : index (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modificationScroll");
			//attribute : scroll (optionnal : false)
			
			LDTTrace.mainModel.createObselType("apparitionPlayer");
			//attribute : volume (optionnal : false)
			//attribute : height (optionnal : false)
			//attribute : x (optionnal : false)
			//attribute : idPlayer (optionnal : false)
			//attribute : y (optionnal : false)
			//attribute : width (optionnal : false)
			
			LDTTrace.mainModel.createObselType("changementVolumeVideo");
			//attribute : idPlayer (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("changementMediaPlayer");
			//attribute : idPlayer (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("changementPositionVideo");
			//attribute : lecture (optionnal : false)
			//attribute : nouvellePosition (optionnal : false)
			//attribute : anciennePosition (optionnal : false)
			//attribute : idPlayer (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("affichageDetailsAnnotation");
			//attribute : modeEdition (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : idMedia (optionnal : false)
			//attribute : obselCause (optionnal : true)
			//attribute : cause (optionnal : true)
			
			LDTTrace.mainModel.createObselType("affichageTab");
			//attribute : nomTab (optionnal : false)
			
			LDTTrace.mainModel.createObselType("stopVideo");
			//attribute : idPlayer (optionnal : false)
			//attribute : positionTemps (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("pauseVideo");
			//attribute : idPlayer (optionnal : false)
			//attribute : positionTemps (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("sauvegardeVue");
			//attribute : positionTemps (optionnal : false)
			//attribute : decoupagesAffiches (optionnal : false)
			//attribute : idVue (optionnal : false)
			//attribute : infoBAB (optionnal : false)
			//attribute : createur (optionnal : false)
			//attribute : contributeur (optionnal : false)
			//attribute : tagsSelectionnes (optionnal : false)
			//attribute : zoom (optionnal : false)
			//attribute : titre (optionnal : false)
			//attribute : mediaSelectionne (optionnal : false)
			//attribute : scroll (optionnal : false)
			//attribute : audio (optionnal : false)
			
			LDTTrace.mainModel.createObselType("sauvegardeProjet");
			//attribute : copyFileName (optionnal : false)
			//attribute : idProjet (optionnal : false)
			//attribute : format (optionnal : false)
			//attribute : requestUrl (optionnal : false)
			
			LDTTrace.mainModel.createObselType("creationVue");
			//attribute : positionTemps (optionnal : false)
			//attribute : decoupagesAffiches (optionnal : false)
			//attribute : idVue (optionnal : false)
			//attribute : infoBAB (optionnal : false)
			//attribute : createur (optionnal : false)
			//attribute : contributeur (optionnal : false)
			//attribute : tagsSelectionnes (optionnal : false)
			//attribute : zoom (optionnal : false)
			//attribute : titre (optionnal : false)
			//attribute : mediaSelectionne (optionnal : false)
			//attribute : scroll (optionnal : false)
			//attribute : audio (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modificationTitreVue");
			//attribute : ancienTitre (optionnal : false)
			//attribute : titre (optionnal : false)
			//attribute : idVue (optionnal : false)
			
			LDTTrace.mainModel.createObselType("affichageSousTab");
			//attribute : nomTab (optionnal : false)
			//attribute : tabParent (optionnal : false)
			//attribute : obselCause (optionnal : true)
			
			LDTTrace.mainModel.createObselType("affichageBABZone");
			
			LDTTrace.mainModel.createObselType("masquageMedia");
			//attribute : index (optionnal : false)
			//attribute : titreMedia (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("masquageDecoupage");
			//attribute : obselCause (optionnal : true)
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("masquageBABZone");
			
			LDTTrace.mainModel.createObselType("lectureVideo");
			//attribute : idPlayer (optionnal : false)
			//attribute : positionTemps (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("masquerDecoupage");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("creerDecoupage");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("creationDecoupage");
			//attribute : idMedia (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : titre (optionnal : false)
			
			LDTTrace.mainModel.createObselType("selectionnerDecoupage");
			//attribute : interactiveAction (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modifierTitreDecoupage");
			//attribute : interactiveAction (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : elementUtilise (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modificationDecoupage");
			//attribute : propriete (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("supprimerDecoupage");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("suppressionDecoupage");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("sortirModeEditionDecoupage");
			//attribute : interactiveAction (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("sortieModeEditionDecoupage");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("selectionnerAnnotation");
			//attribute : interactiveAction (optionnal : true)
			//attribute : idDecoupage (optionnal : false)
			//attribute : interactiveElement (optionnal : true)
			//attribute : modeEdition (optionnal : false)
			//attribute : modeSelection (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("entreeModeEditionDecoupage");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("entrerModeEditionDecoupage");
			//attribute : interactiveAction (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("poserAnnotation");
			//attribute : interactiveAction (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("creationAnnotation");
			//attribute : idDecoupage (optionnal : false)
			//attribute : titreDefaut (optionnal : false)
			//attribute : couleur (optionnal : false)
			//attribute : obselCause (optionnal : false)
			//attribute : tagList (optionnal : false)
			//attribute : type (optionnal : false)
			//attribute : createur (optionnal : false)
			//attribute : contributeur (optionnal : false)
			//attribute : tempsFinMedia (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : descriptionDefaut (optionnal : false)
			//attribute : tempsDebutMedia (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("supprimerAnnotation");
			//attribute : idAnnotation (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("suppressionAnnotation");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : obselCause (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("mettreEnLecturePlayer");
			//attribute : idPlayer (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("mettreEnPausePlayer");
			//attribute : idPlayer (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modifierTitreAnnotation");
			//attribute : interactiveAction (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : elementUtilise (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modificationAnnotation");
			//attribute : idAnnotation (optionnal : false)
			//attribute : propriete (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : idDecoupage (optionnal : true)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			//attribute : obselCause (optionnal : true)
			
			LDTTrace.mainModel.createObselType("modifierTagsAnnotation");
			//attribute : interactiveAction (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : elementUtilise (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modifierDescriptionAnnotation");
			//attribute : interactiveAction (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : elementUtilise (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("finVideo");
			//attribute : idPlayer (optionnal : false)
			//attribute : positionTemps (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("sauvegarderProjet");
			//attribute : nomUtilisateur (optionnal : false)
			//attribute : idProjet (optionnal : false)
			
			LDTTrace.mainModel.createObselType("dupliquerAnnotation");
			//attribute : idMedia (optionnal : false)
			//attribute : idDecoupage (optionnal : false)
			//attribute : type (optionnal : false)
			//attribute : idDecoupageAnnotationDupliquee (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : idAnnotationDupliquee (optionnal : false)
			
			LDTTrace.mainModel.createObselType("creationAnnotationParDuplication");
			//attribute : idDecoupage (optionnal : false)
			//attribute : idDecoupageAnnotationDupliquee (optionnal : false)
			//attribute : tempsDebutMedia (optionnal : false)
			//attribute : couleur (optionnal : false)
			//attribute : obselCause (optionnal : false)
			//attribute : idAnnotationDupliquee (optionnal : false)
			//attribute : tagList (optionnal : false)
			//attribute : type (optionnal : false)
			//attribute : createur (optionnal : false)
			//attribute : contributeur (optionnal : false)
			//attribute : tempsFinMedia (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : descriptionDefaut (optionnal : false)
			//attribute : titreDefaut (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modifierTempsDebutAnnotation");
			//attribute : interactiveAction (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : modeModification (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modifierTempsFinAnnotation");
			//attribute : interactiveAction (optionnal : false)
			//attribute : idAnnotation (optionnal : false)
			//attribute : modeModification (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("creationBAB");
			//attribute : idBab (optionnal : false)
			//attribute : titre (optionnal : false)
			//attribute : resume (optionnal : false)
			
			LDTTrace.mainModel.createObselType("lectureBab");
			
			LDTTrace.mainModel.createObselType("modifierTitreBab");
			//attribute : interactiveAction (optionnal : false)
			//attribute : interactiveElement (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : idBab (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			
			LDTTrace.mainModel.createObselType("modificationBab");
			//attribute : idBab (optionnal : false)
			//attribute : ancienneValeur (optionnal : false)
			//attribute : propriete (optionnal : false)
			//attribute : nouvelleValeur (optionnal : false)
			
			LDTTrace.mainModel.createObselType("selectionSegmentBab");
			//attribute : idAnnotation (optionnal : false)
			//attribute : idMedia (optionnal : false)
			
			LDTTrace.mainModel.createObselType("passageModePleinEcranPlayer");
			//attribute : idPlayer (optionnal : false)
			
			LDTTrace.mainModel.createObselType("changementModePlayer");
			//attribute : idPlayer (optionnal : false)
			//attribute : mode (optionnal : false)
			//attribute : obselCause (optionnal : false)
			
			LDTTrace.mainModel.createObselType("sessionLDT");
			//attribute : traceUid (optionnal : false)
			
			LDTTrace.mainModel.createRelationType("obselCause");
			
			LDTTrace.mainModel.createAttributeType("idPlayer");
			LDTTrace.mainModel.createAttributeType("newX");
			LDTTrace.mainModel.createAttributeType("newHeight");
			LDTTrace.mainModel.createAttributeType("newY");
			LDTTrace.mainModel.createAttributeType("newWidth");
			LDTTrace.mainModel.createAttributeType("obselCause");
			LDTTrace.mainModel.createAttributeType("nomUtilisateur");
			LDTTrace.mainModel.createAttributeType("idProjet");
			LDTTrace.mainModel.createAttributeType("titre");
			LDTTrace.mainModel.createAttributeType("description");
			LDTTrace.mainModel.createAttributeType("idBab");
			LDTTrace.mainModel.createAttributeType("resume");
			LDTTrace.mainModel.createAttributeType("idVue");
			LDTTrace.mainModel.createAttributeType("zoom");
			LDTTrace.mainModel.createAttributeType("index");
			LDTTrace.mainModel.createAttributeType("titreMedia");
			LDTTrace.mainModel.createAttributeType("idMedia");
			LDTTrace.mainModel.createAttributeType("idDecoupage");
			LDTTrace.mainModel.createAttributeType("scroll");
			LDTTrace.mainModel.createAttributeType("volume");
			LDTTrace.mainModel.createAttributeType("height");
			LDTTrace.mainModel.createAttributeType("x");
			LDTTrace.mainModel.createAttributeType("y");
			LDTTrace.mainModel.createAttributeType("width");
			LDTTrace.mainModel.createAttributeType("nouvelleValeur");
			LDTTrace.mainModel.createAttributeType("lecture");
			LDTTrace.mainModel.createAttributeType("nouvellePosition");
			LDTTrace.mainModel.createAttributeType("anciennePosition");
			LDTTrace.mainModel.createAttributeType("modeEdition");
			LDTTrace.mainModel.createAttributeType("idAnnotation");
			LDTTrace.mainModel.createAttributeType("cause");
			LDTTrace.mainModel.createAttributeType("nomTab");
			LDTTrace.mainModel.createAttributeType("positionTemps");
			LDTTrace.mainModel.createAttributeType("decoupagesAffiches");
			LDTTrace.mainModel.createAttributeType("infoBAB");
			LDTTrace.mainModel.createAttributeType("createur");
			LDTTrace.mainModel.createAttributeType("contributeur");
			LDTTrace.mainModel.createAttributeType("tagsSelectionnes");
			LDTTrace.mainModel.createAttributeType("mediaSelectionne");
			LDTTrace.mainModel.createAttributeType("audio");
			LDTTrace.mainModel.createAttributeType("copyFileName");
			LDTTrace.mainModel.createAttributeType("format");
			LDTTrace.mainModel.createAttributeType("requestUrl");
			LDTTrace.mainModel.createAttributeType("ancienTitre");
			LDTTrace.mainModel.createAttributeType("tabParent");
			LDTTrace.mainModel.createAttributeType("interactiveAction");
			LDTTrace.mainModel.createAttributeType("interactiveElement");
			LDTTrace.mainModel.createAttributeType("ancienneValeur");
			LDTTrace.mainModel.createAttributeType("elementUtilise");
			LDTTrace.mainModel.createAttributeType("propriete");
			LDTTrace.mainModel.createAttributeType("modeSelection");
			LDTTrace.mainModel.createAttributeType("titreDefaut");
			LDTTrace.mainModel.createAttributeType("couleur");
			LDTTrace.mainModel.createAttributeType("tagList");
			LDTTrace.mainModel.createAttributeType("type");
			LDTTrace.mainModel.createAttributeType("tempsFinMedia");
			LDTTrace.mainModel.createAttributeType("descriptionDefaut");
			LDTTrace.mainModel.createAttributeType("tempsDebutMedia");
			LDTTrace.mainModel.createAttributeType("idDecoupageAnnotationDupliquee");
			LDTTrace.mainModel.createAttributeType("idAnnotationDupliquee");
			LDTTrace.mainModel.createAttributeType("modeModification");
			LDTTrace.mainModel.createAttributeType("mode");
			LDTTrace.mainModel.createAttributeType("traceUid");
			
			}
		}
			
		public static function trace(typeUri: String, props: Object = null, begin: Number = NaN, end: Number = NaN, uri:String = ""): Obsel
		{
			//attribute props must be an Object formatted like this : o[attribute or relation uri : String] = value:* 
			
			if(mainTrace)
			{
				var obsType:ObselType = null;
				
				if(mainBase.get(typeUri) && mainBase.get(typeUri) is ObselType)
					obsType = mainBase.get(typeUri) as ObselType;
				
				if(!obsType && modelStrict)
				{
					//Avertissement		
				}
				else
				{
					obsType = mainTrace.model.createObselType(typeUri);
				}
				
				var attributes:Array = [];
				var outRelations:Array = [];
				for(var p:String in props)
				{
					var res:Resource = mainTrace.base.get(p);
					
					if(!res && !modelStrict) // if needed, we create undeclared attribute or relation types
					{
						var prop:* = props[p];
						
						if(props[p] is String && mainBase.get(props[p]) && mainBase.get(props[p]) is Obsel)
							prop = mainBase.get(props[p])
						
						if(prop is Obsel)	 // then it is a relation
							res = mainTrace.model.createRelationType(p);
						else				//it is an attribute
							res = mainTrace.model.createAttributeType(p); 
					}
					
					
					if(res && res is AttributeType)
					{
						attributes.push(new Attribute(res as AttributeType, props[p]));
					}
					else if (res && res is RelationType)
					{
						var target:Obsel = null;
						if(props[p] && props[p] is Obsel)
							target = props[p];
						else if( props[p] is String && mainTrace.base.get(props[p]) is Obsel)
							target = mainTrace.base.get(props[p]) as Obsel;
						
						outRelations.push(new Relation(res as RelationType,null,target));
					}
					else if(modelStrict)
					{
						//error
					}
				}
					
				return mainTrace.createObsel(obsType,begin,end,null,null,attributes,outRelations,null,null);
					
			}
			
			return null;
		}
	}
}