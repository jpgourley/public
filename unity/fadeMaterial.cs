/*
 * Description:		Controls material alpha for all object children
 * Pre-Conditions:  Script is assigned to prefab with animation, an animation event trigger object with correct parameters set
 * Post-Conditions:	Material is set to desired alpha at the end of the set duration for all children
 * Use:				Unity > Inspector > Animations > Events > Edit Animation Event 
 * 					Function: 	setFade
 * 					Float:		[Set duration for fade]
 * 					Int:		N/A
 * 					String:		[fadeStop, fadeIn, fadeOut, fadePingPong]
 */

using UnityEngine;
using System;

public class fadeMaterial : MonoBehaviour {

	// Private Variables
	// Expose const parameters in editor if desired for realtime manipulation of values
	private const float minOpacity = 0.0f;
	private const float maxOpacity = 1.0f;
	private const float startDefault = 0.0f;
	private const float durationDefault = 1.0f;
	private const float precisionSlack = 0.05f;

	private enum fadeOperation {fadeStop, 
								fadeIn, 
								fadeOut, 
								fadePingPong};

	private Color AlphaOpaque = new Vector4(1.0f,1.0f,1.0f,maxOpacity);
	private Color AlphaTransparent = new Vector4(1.0f, 1.0f, 1.0f, minOpacity);

	private float duration;
	private float startTime;
	private int fadeType;
	private Renderer[] allChildren;

	// Initialization
	void Start () {
		setFade ();
		allChildren = GetComponentsInChildren<Renderer>(); // Get all child renderer objects at initialization
	}
	
	// Update is called once per frame
	void Update () {
		switch (fadeType) {
			case (int)fadeOperation.fadeStop:
				break;
			case (int)fadeOperation.fadeIn:
				fadeIn ();
				break;
			case (int)fadeOperation.fadeOut:
				fadeOut ();
				break;
			case (int)fadeOperation.fadePingPong:
				fadePingPong();
				break;
			default:
				print("fadeMaterial.cs : Unexpected operation value : " + fadeType);
				break;	
		}
	}

	/* setFade(AnimationEvent)
	 * Set type of fade and duration based on animationEvent parameters
	 */
	void setFade(AnimationEvent animationEvent){
		try {
			// Set fade type
			if (animationEvent.stringParameter != null) {  // Check for null string
				if (Enum.IsDefined(typeof(fadeOperation),animationEvent.stringParameter)){
					fadeType = (int)Enum.Parse(typeof(fadeOperation), animationEvent.stringParameter);
				} else {
					fadeType = (int)fadeOperation.fadeStop;
				}
			} else {
				fadeType = (int)fadeOperation.fadeStop;
			}

			// Set fade duration
			if (!float.IsNaN (animationEvent.floatParameter)) {
				duration = animationEvent.floatParameter;
			} else {
				duration = durationDefault;
			}

			// Set start time for tracking time offset
			startTime = Time.time;
		} catch (System.Exception ex) {
			print (ex.ToString());
		}
	}
	
	/* setFade()
	 * Overloaded to set back to default state when no parameters are passed
	 */
	void setFade(){
		fadeType = (int)fadeOperation.fadeStop;
		duration = durationDefault;
		startTime = startDefault;
	}

	/* fadeIn()
	 * Fade in material for all child objects from alpha min to max over the duration time
	 */
	private void fadeIn(){
		try {
			float lerp = Mathf.Lerp (minOpacity, maxOpacity, ((Time.time - startTime)) / duration);
			if (lerp > (maxOpacity - precisionSlack)) { // Check for float inaccuracy near target 
				foreach (Renderer child in allChildren) { // Target alpha reached
					child.gameObject.GetComponent<Renderer> ().material.color = AlphaOpaque;
				}
				setFade ();
			} else {
				foreach (Renderer child in allChildren) { // Transition alpha
					child.gameObject.GetComponent<Renderer> ().material.color = Color.Lerp (AlphaTransparent, AlphaOpaque, lerp);
				}
			}
		} catch (System.Exception ex) {
			print (ex.ToString());
		}
	}
	
	/* fadeOut()
	 * Fade out material for all child objects from alpha max to min over the duration time
	 */
	private void fadeOut(){
		try {
			float lerp = Mathf.Lerp (minOpacity, maxOpacity, ((Time.time - startTime)) / duration);
			if (lerp > (maxOpacity - precisionSlack)) { // Check for float inaccuracy near target to finish transition
				foreach (Renderer child in allChildren) { // Target alpha reached
					child.gameObject.GetComponent<Renderer> ().material.color = AlphaTransparent;
				}
				setFade ();
			} else {
				foreach (Renderer child in allChildren) { // Transition alpha
					child.gameObject.GetComponent<Renderer> ().material.color = Color.Lerp (AlphaOpaque, AlphaTransparent, lerp);
				}
			}
		} catch (System.Exception ex) {
			print (ex.ToString());
		}
	}

	/* fadePingPong()
	 * Fade back and forth between alpha min and max over the duration time
	 */
	private void fadePingPong(){
		try {
			float lerp = Mathf.PingPong (Time.time, duration) / duration;
			foreach (Renderer child in allChildren) {
				child.gameObject.GetComponent<Renderer> ().material.color = Color.Lerp (AlphaOpaque, AlphaTransparent, lerp);
			}
		} catch (System.Exception ex) {
			print (ex.ToString());
		}
	}
}
