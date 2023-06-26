package com.example.shormeh_pos_9_1_2023;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;


import com.imin.library.IminSDKManager;
import com.imin.library.SystemPropManager;
import com.imin.printerlib.IminPrintUtils;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.SoftReference;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import android.app.Presentation;
import android.view.Display;
import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;


import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.hardware.display.DisplayManager;

import android.net.Uri;

import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.TextView;

import android.widget.VideoView;




import com.squareup.picasso.Picasso;
import com.bumptech.glide.annotation.GlideModule;
import com.bumptech.glide.module.AppGlideModule;




public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.imin.printersdk";
    private static MethodChannel.Result scanResult;

    private IminPrintUtils.PrintConnectType connectType = IminPrintUtils.PrintConnectType.USB;
    private Presentation presentation;
    private static final String TAG = "display_demo";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(
            (call, result) -> {
        if (call.method.equals("sdkInit")) {
            String deviceModel = SystemPropManager.getModel();
            if(deviceModel.contains("M2-203") ||deviceModel.contains("M2-202")|| deviceModel.contains("M2 Pro") ){
                connectType = IminPrintUtils.PrintConnectType.SPI;
            }else {
                connectType = IminPrintUtils.PrintConnectType.USB;
            }
            IminPrintUtils.getInstance(MainActivity.this).initPrinter(connectType);
            result.success("init");
        }else if(call.method.equals("getStatus")){
            int status =
            IminPrintUtils.getInstance(MainActivity.this).getPrinterStatus(connectType);
            result.success(String.format("%d",status));
        }else if(call.method.equals("printText")){
            if(call.arguments() == null) return;
            String text = ((List)call.arguments()).get(0).toString();
            int textSize = Integer.parseInt(((List)call.arguments()).get(1).toString());
            int alignment = Integer.parseInt(((List)call.arguments()).get(2).toString());
            IminPrintUtils mIminPrintUtils =
            IminPrintUtils.getInstance(MainActivity.this);
            mIminPrintUtils.setAlignment(alignment);
            mIminPrintUtils.setTextSize(textSize);
            mIminPrintUtils.printText(text + "   \n");
            result.success(text);
        }else if(call.method.equals("feed")){
            IminPrintUtils mIminPrintUtils = IminPrintUtils.getInstance(MainActivity.this);
            mIminPrintUtils.printAndLineFeed();
            mIminPrintUtils.printAndFeedPaper(5);
            result.success("feed");
        }else if(call.method.equals("printQr")){
            IminPrintUtils mIminPrintUtils = IminPrintUtils.getInstance(MainActivity.this);
            String text = ((List)call.arguments()).get(0).toString();
            mIminPrintUtils.printQrCode(text, 1);
            result.success("printQr");
        }else if(call.method.equals("getSn")){
            String sn = "";
            if (Build.VERSION.SDK_INT >= 30) {
                sn = SystemPropManager.getSystemProperties("persist.sys.imin.sn");
            } else {
                sn = SystemPropManager.getSn();
            }
            result.success(sn);
        }else if(call.method.equals("opencashBox")){
            IminSDKManager.opencashBox();
            result.success("opencashBox");
        }else if (call.method.equals("printBitmap")){
            byte[] image = call.argument("image");
            Bitmap bitmap = null;
            bitmap = byteToBitmap(image);
            IminPrintUtils mIminPrintUtils =
            IminPrintUtils.getInstance(MainActivity.this);
            mIminPrintUtils.printSingleBitmap(bitmap);
            result.success("printBitmap");
        }
        else if (call.method.equals("paperCutter")){
            IminPrintUtils mIminPrintUtils =
                    IminPrintUtils.getInstance(MainActivity.this);
            mIminPrintUtils.partialCut();
        }
        else if (call.method.equals("showImage")){
            showSecondByDisplayManager(MainActivity.this);
                if(presentation != null){
                    String url = ((List)call.arguments()).get(0).toString();
                    ImageView imageView = presentation.findViewById(R.id.image);
                    imageView.setVisibility(View.VISIBLE);
//                    imageView.setImageResource(R.drawable.sss);
                    Picasso.get().load(url).into(imageView);
//                    imageView.setImageURI(URI(url));
                    result.success("showImage");

                }


        }
    }
        );
    }


    public static Bitmap byteToBitmap(byte[] imgByte) {
        InputStream input = null;
        Bitmap bitmap = null;
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inSampleSize = 1;
        input = new ByteArrayInputStream(imgByte);
        SoftReference softRef = new SoftReference(BitmapFactory.decodeStream(
            input, null, options));  //�����÷�ֹOOM
        bitmap = (Bitmap) softRef.get();
        if (imgByte != null) {
            imgByte = null;
        }

        try {
            if (input != null) {
                input.close();
            }
        } catch (IOException e) {
            // �쳣����
            e.printStackTrace();
        }
        return bitmap;
    }

    private void showSecondByDisplayManager(Context context) {
        DisplayManager mDisplayManager = (DisplayManager) getSystemService(Context.DISPLAY_SERVICE);
        Display[] displays = mDisplayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION);
        if (displays != null && getPresentationDisplays() != null) {
            presentation = new DifferentDisplay(context, getPresentationDisplays());
            presentation.show();
        }else {
            Toast.makeText(MainActivity.this,getString(R.string.no_second_screen),Toast.LENGTH_SHORT);
        }
        /*副屏的Window*/

    }

    public Display getPresentationDisplays() {
        DisplayManager mDisplayManager= (DisplayManager)getSystemService(Context.DISPLAY_SERVICE);
        Display[] displays =mDisplayManager.getDisplays();
        if (displays != null){
            for(int i=0;  i < displays.length; i++){
                Log.e(TAG,"屏幕==>" +displays[i] + " Flag:==> " + displays[i].getFlags());
                if((displays[i].getFlags() & Display.FLAG_SECURE)!=0
                        &&(displays[i].getFlags() & Display.FLAG_SUPPORTS_PROTECTED_BUFFERS)!=0
                        &&(displays[i].getFlags() & Display.FLAG_PRESENTATION) !=0){
                    Log.e(TAG,"第一个真实存在的副屏屏幕==> " + displays[i]);
                    return displays[i];
                }
            }
        }

        return null;
    }


}
