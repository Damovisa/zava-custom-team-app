import { useState, useRef, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Card } from "@/components/ui/card";
import { Camera, FloppyDisk } from "@phosphor-icons/react";

interface WebcamCaptureProps {
  onImageCapture: (imageSrc: string) => void;
}

export function WebcamCapture({ onImageCapture }: WebcamCaptureProps) {
  const [open, setOpen] = useState(false);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [capturedImage, setCapturedImage] = useState<string | null>(null);
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  const startCamera = useCallback(async () => {
    try {
      const mediaStream = await navigator.mediaDevices.getUserMedia({ 
        video: { 
          facingMode: "user",
          width: { ideal: 640 },
          height: { ideal: 480 }
        } 
      });
      
      setStream(mediaStream);
      
      if (videoRef.current) {
        videoRef.current.srcObject = mediaStream;
      }
    } catch (error) {
      console.error("Error accessing webcam:", error);
    }
  }, []);

  const stopCamera = useCallback(() => {
    if (stream) {
      stream.getTracks().forEach(track => track.stop());
      setStream(null);
    }
  }, [stream]);

  const capturePhoto = useCallback(() => {
    if (videoRef.current && canvasRef.current) {
      const video = videoRef.current;
      const canvas = canvasRef.current;
      const context = canvas.getContext('2d');
      
      if (context) {
        // Set canvas dimensions to match video
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        
        // Draw the current video frame to the canvas
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
        
        // Convert canvas to data URL and set as captured image
        const imageDataURL = canvas.toDataURL('image/png');
        setCapturedImage(imageDataURL);
      }
    }
  }, []);

  const handleSaveImage = useCallback(() => {
    if (capturedImage) {
      onImageCapture(capturedImage);
      setCapturedImage(null);
      setOpen(false);
      stopCamera();
    }
  }, [capturedImage, onImageCapture, stopCamera]);

  const handleOpenChange = (isOpen: boolean) => {
    setOpen(isOpen);
    if (isOpen) {
      startCamera();
      setCapturedImage(null);
    } else {
      stopCamera();
    }
  };

  const handleRetake = useCallback(() => {
    setCapturedImage(null);
  }, []);

  return (
    <Dialog open={open} onOpenChange={handleOpenChange}>
      <DialogTrigger asChild>
        <Button variant="secondary" className="w-full">
          <Camera className="mr-2" />
          Take Photo with Webcam
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Take a Photo</DialogTitle>
        </DialogHeader>
        <div className="webcam-container bg-muted rounded-md overflow-hidden">
          {!capturedImage ? (
            <>
              <video 
                ref={videoRef} 
                autoPlay 
                playsInline 
                className="w-full h-auto"
                style={{ display: stream ? 'block' : 'none' }}
              />
              <Button 
                onClick={capturePhoto} 
                variant="secondary" 
                className="mt-4 mx-auto block"
                disabled={!stream}
              >
                <Camera className="mr-2" />
                Capture
              </Button>
            </>
          ) : (
            <Card className="p-2">
              <img 
                src={capturedImage} 
                alt="Captured" 
                className="w-full h-auto rounded-md" 
              />
              <div className="flex gap-2 mt-4">
                <Button 
                  onClick={handleRetake}
                  variant="outline"
                  className="flex-1"
                >
                  Retake
                </Button>
                <Button 
                  onClick={handleSaveImage}
                  className="flex-1"
                >
                  <FloppyDisk className="mr-2" />
                  Use Photo
                </Button>
              </div>
            </Card>
          )}
          <canvas ref={canvasRef} style={{ display: 'none' }} />
        </div>
      </DialogContent>
    </Dialog>
  );
}