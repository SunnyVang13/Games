package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class ActorEvents_0 extends ActorScript
{
	public var _Grounded:Bool;
	public var _BulletSpeed:Float;
	public var _HealthPoints:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Grounded?", "_Grounded");
		_Grounded = false;
		nameMap.set("Bullet Speed", "_BulletSpeed");
		_BulletSpeed = 35.0;
		nameMap.set("Health Points", "_HealthPoints");
		_HealthPoints = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(isKeyDown("left"))
				{
					actor.setXVelocity(-10);
					actor.setAnimation("" + "Walking Left");
				}
				else if(isKeyDown("right"))
				{
					actor.setXVelocity(10);
					actor.setAnimation("" + "Walking Right");
				}
				else
				{
					actor.setXVelocity(0);
				}
				if(isKeyDown("down"))
				{
					actor.setYVelocity(10);
					actor.setAnimation("" + "Walking Down");
				}
				else if(isKeyDown("up"))
				{
					actor.setYVelocity(-10);
					actor.setAnimation("" + "Walking Up");
				}
				else
				{
					actor.setYVelocity(0);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(16), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				actor.setAnimation("" + "Power Up");
				recycleActor(event.otherActor);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("Hero X", actor.getX());
				Engine.engine.setGameAttribute("Hero Y", actor.getY());
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("action1", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				createRecycledActor(getActorType(6), actor.getX(), actor.getY(), Script.FRONT);
				if((actor.getAnimation() == "Walking Down"))
				{
					getLastCreatedActor().setYVelocity(_BulletSpeed);
				}
				else if((actor.getAnimation() == "Walking Up"))
				{
					getLastCreatedActor().setYVelocity(-(_BulletSpeed));
				}
				else if((actor.getAnimation() == "Walking Right"))
				{
					getLastCreatedActor().setXVelocity(_BulletSpeed);
				}
				else
				{
					getLastCreatedActor().setXVelocity(-(_BulletSpeed));
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}