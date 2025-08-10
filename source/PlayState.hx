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
	var version:String = "v1.0.2";

	var flixelMemeLogo:FlxSprite = new FlxSprite().loadGraphic("assets/images/flx-meme-logo.png");
	var openImageButton:FlxButton;

	var resetImagesButton:FlxButton;
	var resetImagesPositionButton:FlxButton;
	var centerTextsXButton:FlxButton;
	var centerTextsYButton:FlxButton;
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

	var angleTopText:Int = 0;
	var angleBottomText:Int = 0;

	var angleImage:Int = 0;

	var initialTextY:Int = 510;

	var draggableImage:Bool = false;
	var draggableText:Bool = true;

	override public function create()
	{
		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 1, true, null, true);

		versionText.size = 24;
		versionText.text = version;
		versionText.x = FlxG.width - versionText.width;
		versionText.alpha = 0.5;

		topText.size = 64;
		topText.text = "TOP TEXT";
		topText.font = "assets/fonts/impact.ttf";
		topText.angle = angleTopText;
		topText.screenCenter(X);
		topText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);

		bottomText.size = 64;
		bottomText.text = "BOTTOM TEXT";
		bottomText.font = "assets/fonts/impact.ttf";
		bottomText.angle = angleBottomText;
		bottomText.screenCenter(X);
		bottomText.y = FlxG.height - (FlxG.height / 10);
		bottomText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);

		controlsNoticeText.size = 16;
		controlsNoticeText.text = "F1 - Toggle Watermark \nF2 - Toggle Mouse \nF3 - Toggle UI\nF4 - Toggle All\nF5 - Toggle Draggable Image\nF6 - Toggle Draggable Texts\n\nQ/E+Click - Angle Text + Images \n1+Click - Reset Angle - Text + Images\n(If Draggable)";
		controlsNoticeText.y = initialTextY;
		controlsNoticeText.x = 5;

		meme.visible = false;
		meme.angle = angleImage;
		add(meme);

		add(topText);
		add(bottomText);

		add(topTextInput);
		add(bottomTextInput);

		add(controlsNoticeText);

		openImageButton = new FlxButton(0, 0, "Load - Image", onLoadImage);
		openImageButton.setGraphicSize(200, 40);
		openImageButton.screenCenter();

		resetImagesButton = new FlxButton(10, 680, "Reset Meme", resetImage);
		resetImagesPositionButton = new FlxButton(10, 710, "Reset Meme POS", resetImagePosition);
		centerTextsXButton = new FlxButton(10, 740, "Center Texts X", centerTextsX);
		centerTextsYButton = new FlxButton(10, 770, "Center Texts Y", centerTextsY);
		resetTextPositionsButton = new FlxButton(10, 830, "Reset Text POS", resetTextPositions);
		resetTextsButton = new FlxButton(10, 800, "Reset Text", resetTexts);

		flixelMemeLogo.alpha = 0.5;
		add(flixelMemeLogo);
		add(versionText);
		add(openImageButton);

		add(resetImagesButton);
		add(resetImagesPositionButton);
		resetImagesButton.visible = false;
		resetImagesPositionButton.visible = false;
		add(centerTextsXButton);
		add(centerTextsYButton);
		add(resetTextsButton);
		add(resetTextPositionsButton);
	}

	public function centerTextsX()
	{
		topText.screenCenter(X);
		bottomText.screenCenter(X);
		trace("Centered texts on X-Axis.");
	}

	public function centerTextsY()
	{
		topText.screenCenter(Y);
		bottomText.screenCenter(Y);
		trace("Centered texts on Y-Axis.");
	}

	public function resetImagePosition()
	{
		meme.screenCenter();
		trace("Reset image.");
	}

	public function resetImage()
	{
		meme.loadGraphic("assets/images/tempMeme.png");
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
		openImageButton.x = FlxG.width - 150;
		openImageButton.y  = FlxG.height - 50;
		meme.loadGraphic(bmpData);
		meme.visible = true;
		meme.screenCenter();
		resetImagesButton.visible = true;
		resetImagesPositionButton.visible = true;
		controlsNoticeText.y = initialTextY - 50;
		imageLoaded = true;
	}

	public function toggleWatermark()
	{
		watermarkEnabled = !watermarkEnabled;
		trace("Watermark Enabled ? - " + watermarkEnabled);
	}

	public function toggleCursor()
	{
		FlxG.mouse.visible = !FlxG.mouse.visible;
		trace("Cursor Visible ? - " + FlxG.mouse.visible);
	}

	public function toggleUi()
	{
		versionText.visible = !versionText.visible;
		controlsNoticeText.visible = !controlsNoticeText.visible;
		topTextInput.visible = !topTextInput.visible;
		bottomTextInput.visible = !bottomTextInput.visible;
		openImageButton.visible = !openImageButton.visible;
		centerTextsXButton.visible = !centerTextsXButton.visible;
		centerTextsYButton.visible = !centerTextsYButton.visible;
		resetTextPositionsButton.visible = !resetTextPositionsButton.visible;
		resetTextsButton.visible = !resetTextsButton.visible;

		if (imageLoaded)
		{
			resetImagesButton.visible = !resetImagesButton.visible;
			resetImagesPositionButton.visible = !resetImagesPositionButton.visible;
		} else {
			resetImagesButton.visible = false;
			resetImagesPositionButton.visible = false;
		}

		uiToggled = !uiToggled;
		trace("UI toggled ? - " + uiToggled);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		topText.text = topTextInput.text;
		bottomText.text = bottomTextInput.text;

		topText.angle = angleTopText;
		bottomText.angle = angleBottomText;

		meme.angle = angleImage;

		if (FlxG.mouse.overlaps(meme) && draggableImage)
		{
			meme.alpha = 0.5;
			if (FlxG.mouse.pressed)
			{
				meme.x = FlxG.mouse.getPosition().x - meme.width / 2;
				meme.y = FlxG.mouse.getPosition().y - meme.height / 2;

				if (FlxG.keys.justPressed.E)
				{
					angleImage += 10;
					FlxG.sound.play("assets/sounds/rotateRight.ogg");
				} else if (FlxG.keys.justPressed.Q) {
					angleImage -= 10;
					FlxG.sound.play("assets/sounds/rotateLeft.ogg");
				} else if (FlxG.keys.justPressed.ONE) {
					angleImage = 0;
					FlxG.sound.play("assets/sounds/rotateReset.ogg");
				}
			}
		} else {
			meme.alpha = 1;
		}

		if (FlxG.mouse.overlaps(topText) && draggableText)
		{
			topText.color = FlxColor.GRAY;
			if (FlxG.mouse.pressed)
			{
				topText.x = FlxG.mouse.getPosition().x - topText.width / 2;
				topText.y = FlxG.mouse.getPosition().y - topText.height / 2;

				if (FlxG.keys.justPressed.E)
				{
					angleTopText += 10;
					FlxG.sound.play("assets/sounds/rotateRight.ogg");
				} else if (FlxG.keys.justPressed.Q) {
					angleTopText -= 10;
					FlxG.sound.play("assets/sounds/rotateLeft.ogg");
				} else if (FlxG.keys.justPressed.ONE) {
					angleTopText = 0;
					FlxG.sound.play("assets/sounds/rotateReset.ogg");
				}
			}
		} else {
			topText.color = FlxColor.WHITE;
		}

		if (FlxG.mouse.overlaps(bottomText) && draggableText)
		{
			bottomText.color = FlxColor.GRAY;
			if (FlxG.mouse.pressed)
			{
				bottomText.x = FlxG.mouse.getPosition().x - bottomText.width / 2;
				bottomText.y = FlxG.mouse.getPosition().y - bottomText.height / 2;

				if (FlxG.keys.justPressed.E)
				{
					angleBottomText += 10;
					FlxG.sound.play("assets/sounds/rotateRight.ogg");
				} else if (FlxG.keys.justPressed.Q) {
					angleBottomText -= 10;
					FlxG.sound.play("assets/sounds/rotateLeft.ogg");
				} else if (FlxG.keys.justPressed.ONE) {
					angleBottomText = 0;
					FlxG.sound.play("assets/sounds/rotateReset.ogg");
				}
			}
		} else {
			bottomText.color = FlxColor.WHITE;
		}

		if (FlxG.keys.justPressed.F1)
		{
			toggleWatermark();
		}

		if (FlxG.keys.justPressed.F2)
		{
			toggleCursor();
		}

		if (FlxG.keys.justPressed.F3)
		{
			toggleUi();
		}

		if (FlxG.keys.justPressed.F4)
		{
			toggleWatermark();
			toggleCursor();
			toggleUi();
		}

		if (FlxG.keys.justPressed.F5)
		{
			draggableImage = !draggableImage;
		}

		if (FlxG.keys.justPressed.F6)
		{
			draggableText = !draggableText;
		}

		if (FlxG.mouse.justPressed)
		{
			FlxG.sound.play("assets/sounds/clickPress.ogg");
		}

		if (FlxG.mouse.justReleased)
		{
			FlxG.sound.play("assets/sounds/clickRelease.ogg");
		}

		flixelMemeLogo.visible = watermarkEnabled;
	}
}
