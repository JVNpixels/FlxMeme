package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.text.FlxInputText;
import flixel.util.FlxColor;
import flash.geom.Matrix;
import flixel.ui.FlxButton;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import flash.events.Event;
import flash.display.Bitmap;
import flash.display.BitmapData;

class PlayState extends FlxState
{
	var version:String = "v1.0.0";

	var flixelMemeLogo:FlxSprite = new FlxSprite().loadGraphic("assets/images/flx-meme-logo.png");
	var openImageButton:FlxButton;

	var resetImagesButton:FlxButton;
	var centerTextsXButton:FlxButton;
	var resetTextsButton:FlxButton;
	var resetTextPositionsButton:FlxButton;

	var meme:FlxSprite = new FlxSprite().loadGraphic("assets/images/tempMeme.png"); // The center of it all!

	var versionText:FlxText = new FlxText();
	
	var topText:FlxText = new FlxText();
	var bottomText:FlxText = new FlxText();

	var controlsNoticeText:FlxText = new FlxText();

	var topTextInput:FlxInputText = new FlxInputText(10, FlxG.height - (FlxG.height / 10), 0, "TOP TEXT", 24);
	var bottomTextInput:FlxInputText = new FlxInputText(10, FlxG.height - (FlxG.height / 10) + 50, 0, "BOTTOM TEXT", 24);

	var watermarkEnabled:Bool = true;
	var uiToggled:Bool = true;

	var imageLoaded:Bool = false;

	override public function create()
	{
		super.create();

		versionText.size = 24;
		versionText.text = version;
		versionText.x = FlxG.width - versionText.width;
		versionText.alpha = 0.5;

		topText.size = 64;
		topText.text = "TOP TEXT";
		topText.font = "assets/fonts/impact.ttf";
		topText.screenCenter(X);

		bottomText.size = 64;
		bottomText.text = "BOTTOM TEXT";
		bottomText.font = "assets/fonts/impact.ttf";
		bottomText.screenCenter(X);
		bottomText.y = FlxG.height - (FlxG.height / 10);

		controlsNoticeText.size = 16;
		controlsNoticeText.text = "F1 - Hide Watermark \nF2 - Hide Mouse \nF3 - Hide UI";
		controlsNoticeText.y = 690;
		controlsNoticeText.x = 5;

		meme.visible = false;
		add(meme);

		add(topText);
		add(bottomText);

		add(topTextInput);
		add(bottomTextInput);

		add(controlsNoticeText);

		openImageButton = new FlxButton(0, 0, "Load - Image", onLoadImage);
		openImageButton.scale.set(2.5, 2.5);
		openImageButton.screenCenter();

		resetImagesButton = new FlxButton(10, 740, "Reset Image", resetImage);
		centerTextsXButton = new FlxButton(10, 770, "Center Texts X", centerTextsX);
		resetTextPositionsButton = new FlxButton(10, 830, "Reset Text POS", resetTextPositions);
		resetTextsButton = new FlxButton(10, 800, "Reset Text", resetTexts);

		flixelMemeLogo.alpha = 0.5;
		add(flixelMemeLogo);
		add(versionText);
		add(openImageButton);

		add(resetImagesButton);
		resetImagesButton.visible = false;
		add(centerTextsXButton);
		add(resetTextsButton);
		add(resetTextPositionsButton);
	}

	public function centerTextsX()
	{
		topText.screenCenter(X);
		bottomText.screenCenter(X);
		trace("Centered texts on X-Axis.");
	}

	public function resetImage()
	{
		meme.loadGraphic("assets/images/tempMeme.png");
		meme.screenCenter();
		trace("Reset image.");
	}

	public function resetTexts()
	{
		topText.text = "TOP TEXT";
		topTextInput.text = "TOP TEXT";
		bottomText.text = "BOTTOM TEXT";
		bottomTextInput.text = "BOTTOM TEXT";
		trace("Texts have been reset.");
	}

	public function resetTextPositions()
	{
		topText.screenCenter(X);
		topText.y = 0;
		bottomText.screenCenter(X);
		bottomText.y = FlxG.height - (FlxG.height / 10);
		trace("Text positions have been reset.");
	}

	public function onLoadImage()
	{
		var fr:FileReference = new FileReference();
		fr.addEventListener(Event.SELECT, _onSelect, false, 0, true);
		fr.addEventListener(Event.CANCEL, _onCancel, false, 0, true);
		var filters:Array<FileFilter> = new Array<FileFilter>();
		filters.push(new FileFilter("PNG Files", "*.png"));
		filters.push(new FileFilter("JPEG Files", "*.jpg;*.jpeg"));
		fr.browse(filters);
	}

	function _onSelect(E:Event):Void
	{
		var fr:FileReference = cast(E.target, FileReference);
		fr.addEventListener(Event.COMPLETE, _onLoad, false, 0, true);
		fr.load();
	}

	function _onCancel(_):Void
	{
		trace("Operation cancelled.");
	}

	function _onLoad(E:Event):Void
	{
		var fr:FileReference = cast E.target;
		fr.removeEventListener(Event.COMPLETE, _onLoad);

		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onImgLoad);
		loader.loadBytes(fr.data);
	}

	function _onImgLoad(E:Event):Void
	{
		var loader:Loader = cast(E.target.loader, Loader);
    	var bmp:Bitmap = cast(loader.content, Bitmap);
    	var bmpData:BitmapData = bmp.bitmapData;

		trace("Image loaded.");
		openImageButton.x = FlxG.width - 200;
		openImageButton.y  = FlxG.height - 50;
		meme.loadGraphic(bmpData);
		meme.visible = true;
		meme.screenCenter();
		resetImagesButton.visible = true;
		controlsNoticeText.y = 660;
		imageLoaded = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		topText.text = topTextInput.text;
		bottomText.text = bottomTextInput.text;

		if (FlxG.mouse.overlaps(topText))
		{
			topText.color = FlxColor.GRAY;
			if (FlxG.mouse.pressed)
			{
				topText.x = FlxG.mouse.getPosition().x - topText.width / 2;
				topText.y = FlxG.mouse.getPosition().y - topText.height / 2;
			}
		} else {
			topText.color = FlxColor.WHITE;
		}

		if (FlxG.mouse.overlaps(bottomText))
		{
			bottomText.color = FlxColor.GRAY;
			if (FlxG.mouse.pressed)
			{
				bottomText.x = FlxG.mouse.getPosition().x - bottomText.width / 2;
				bottomText.y = FlxG.mouse.getPosition().y - bottomText.height / 2;
			}
		} else {
			bottomText.color = FlxColor.WHITE;
		}

		if (FlxG.keys.justPressed.F1)
		{
			watermarkEnabled = !watermarkEnabled;
			trace("Watermark Enabled ? - " + watermarkEnabled);
		}

		if (FlxG.keys.justPressed.F2)
		{
			FlxG.mouse.visible = !FlxG.mouse.visible;
			trace("Cursor Visible ? - " + FlxG.mouse.visible);
		}

		if (FlxG.keys.justPressed.F3)
		{
			versionText.visible = !versionText.visible;
			controlsNoticeText.visible = !controlsNoticeText.visible;
			topTextInput.visible = !topTextInput.visible;
			bottomTextInput.visible = !bottomTextInput.visible;
			openImageButton.visible = !openImageButton.visible;
			centerTextsXButton.visible = !centerTextsXButton.visible;
			resetTextPositionsButton.visible = !resetTextPositionsButton.visible;
			resetTextsButton.visible = !resetTextsButton.visible;

			if (imageLoaded)
			{
				resetImagesButton.visible = !resetImagesButton.visible;
			} else {
				resetImagesButton.visible = false;
			}

			uiToggled = !uiToggled;
			trace("UI toggled ? - " + uiToggled);
		}

		flixelMemeLogo.visible = watermarkEnabled;
	}
}
