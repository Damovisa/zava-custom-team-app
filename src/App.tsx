import { useState, useEffect } from "react";
import { ProductVisualization } from "@/components/ProductVisualization";
import { WebcamCapture } from "@/components/WebcamCapture";
import { DesignHelper } from "@/components/DesignHelper";
import { ProductType, colorOptions, textColorOptions, sportsData, Sport, League, Team } from "@/lib/data";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";
import { ArrowRight, TShirt, Hoodie, BaseballCap, Wind, Upload, CaretRight, Check } from "@phosphor-icons/react";

function App() {
  // State for product customization
  const [productType, setProductType] = useState<ProductType>("t-shirt");
  const [selectedColor, setSelectedColor] = useState(colorOptions[0].value);
  const [selectedTextColor, setSelectedTextColor] = useState(textColorOptions[0].value);
  const [selectedSport, setSelectedSport] = useState<Sport | null>(null);
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null);
  const [selectedTeam, setSelectedTeam] = useState<Team | null>(null);
  const [userName, setUserName] = useState("");
  const [customImage, setCustomImage] = useState<string | null>(null);
  const [currentStep, setCurrentStep] = useState("product");

  // Set default sport when component mounts
  useEffect(() => {
    if (sportsData.length > 0) {
      setSelectedSport(sportsData[0]);
    }
  }, []);

  // Reset league and team when sport changes
  useEffect(() => {
    if (selectedSport && selectedSport.leagues.length > 0) {
      setSelectedLeague(selectedSport.leagues[0]);
      setSelectedTeam(null);
    } else {
      setSelectedLeague(null);
      setSelectedTeam(null);
    }
  }, [selectedSport]);

  // Reset team when league changes
  useEffect(() => {
    if (selectedLeague && selectedLeague.teams.length > 0) {
      setSelectedTeam(selectedLeague.teams[0]);
    } else {
      setSelectedTeam(null);
    }
  }, [selectedLeague]);

  // Handle file upload for custom image
  const handleFileUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setCustomImage(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  // Handle webcam image capture
  const handleImageCapture = (imageSrc: string) => {
    setCustomImage(imageSrc);
  };

  // Get the product icon based on type
  const getProductIcon = () => {
    switch(productType) {
      case "t-shirt":
        return <TShirt size={24} />;
      case "hoodie":
        return <Hoodie size={24} />;
      case "cap":
        return <BaseballCap size={24} />;
      case "jacket":
        return <Wind size={24} />;
      default:
        return <TShirt size={24} />;
    }
  };

  // Navigate to next step
  const goToNextStep = () => {
    if (currentStep === "product") setCurrentStep("team");
    else if (currentStep === "team") setCurrentStep("personalize");
  };

  // Navigate to previous step  
  const goToPreviousStep = () => {
    if (currentStep === "team") setCurrentStep("product");
    else if (currentStep === "personalize") setCurrentStep("team");
  };

  return (
    <div className="min-h-screen bg-background flex flex-col">
      {/* Design Helper */}
      <DesignHelper />
      
      {/* Header */}
      <header className="border-b py-4 px-6 bg-primary text-primary-foreground">
        <div className="max-w-7xl mx-auto w-full">
          <h1 className="text-2xl font-bold">Zava Athletics</h1>
          <p className="text-sm opacity-80">Custom Apparel Designer</p>
        </div>
      </header>

      {/* Main content */}
      <main className="flex-1 py-8 px-6">
        <div className="max-w-7xl mx-auto grid lg:grid-cols-2 gap-8">
          {/* Left column - Customization controls */}
          <div className="space-y-6">
            <Tabs value={currentStep} onValueChange={setCurrentStep} className="w-full">
              <TabsList className="grid w-full grid-cols-3">
                <TabsTrigger value="product" className="data-[state=active]:bg-accent data-[state=active]:text-accent-foreground">
                  1. Product
                </TabsTrigger>
                <TabsTrigger value="team" className="data-[state=active]:bg-accent data-[state=active]:text-accent-foreground">
                  2. Team
                </TabsTrigger>
                <TabsTrigger value="personalize" className="data-[state=active]:bg-accent data-[state=active]:text-accent-foreground">
                  3. Personalize
                </TabsTrigger>
              </TabsList>

              {/* Step 1: Product Selection */}
              <TabsContent value="product" className="space-y-6 py-4">
                <Card>
                  <CardHeader>
                    <CardTitle>Choose Your Style</CardTitle>
                    <CardDescription>Select the type of apparel you want to customize</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <RadioGroup 
                      value={productType} 
                      onValueChange={(value) => setProductType(value as ProductType)}
                      className="grid grid-cols-2 gap-4"
                    >
                      <Label 
                        htmlFor="t-shirt" 
                        className={`flex flex-col items-center justify-center p-4 rounded-lg border-2 cursor-pointer transition-all ${
                          productType === "t-shirt" ? "border-primary bg-primary/10" : "border-muted hover:border-primary/50"
                        }`}
                      >
                        <RadioGroupItem value="t-shirt" id="t-shirt" className="sr-only" />
                        <TShirt size={48} weight={productType === "t-shirt" ? "fill" : "regular"} />
                        <span className="mt-2 font-medium">T-Shirt</span>
                      </Label>
                      <Label 
                        htmlFor="hoodie" 
                        className={`flex flex-col items-center justify-center p-4 rounded-lg border-2 cursor-pointer transition-all ${
                          productType === "hoodie" ? "border-primary bg-primary/10" : "border-muted hover:border-primary/50"
                        }`}
                      >
                        <RadioGroupItem value="hoodie" id="hoodie" className="sr-only" />
                        <Hoodie size={48} weight={productType === "hoodie" ? "fill" : "regular"} />
                        <span className="mt-2 font-medium">Hoodie</span>
                      </Label>
                      <Label 
                        htmlFor="cap" 
                        className={`flex flex-col items-center justify-center p-4 rounded-lg border-2 cursor-pointer transition-all ${
                          productType === "cap" ? "border-primary bg-primary/10" : "border-muted hover:border-primary/50"
                        }`}
                      >
                        <RadioGroupItem value="cap" id="cap" className="sr-only" />
                        <BaseballCap size={48} weight={productType === "cap" ? "fill" : "regular"} />
                        <span className="mt-2 font-medium">Cap</span>
                      </Label>
                      <Label 
                        htmlFor="jacket" 
                        className={`flex flex-col items-center justify-center p-4 rounded-lg border-2 cursor-pointer transition-all ${
                          productType === "jacket" ? "border-primary bg-primary/10" : "border-muted hover:border-primary/50"
                        }`}
                      >
                        <RadioGroupItem value="jacket" id="jacket" className="sr-only" />
                        <Wind size={48} weight={productType === "jacket" ? "fill" : "regular"} />
                        <span className="mt-2 font-medium">Jacket</span>
                      </Label>
                    </RadioGroup>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader>
                    <CardTitle>Choose a Color</CardTitle>
                    <CardDescription>Select the base color for your {productType}</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <RadioGroup 
                      value={selectedColor}
                      onValueChange={setSelectedColor}
                      className="grid grid-cols-5 gap-3"
                    >
                      {colorOptions.map((color) => (
                        <Label
                          key={color.value}
                          htmlFor={`color-${color.value.substring(1)}`}
                          className="cursor-pointer flex flex-col items-center"
                        >
                          <RadioGroupItem 
                            value={color.value} 
                            id={`color-${color.value.substring(1)}`} 
                            className="sr-only" 
                          />
                          <div className="relative mb-2">
                            <div 
                              className="h-10 w-10 rounded-full shadow-sm transition-all"
                              style={{ 
                                backgroundColor: color.value,
                                border: color.value === "#FFFFFF" ? "1px solid #e2e8f0" : "none",
                              }}
                            />
                            {selectedColor === color.value && (
                              <div className="absolute -top-1 -right-1 h-5 w-5 rounded-full bg-primary text-primary-foreground flex items-center justify-center">
                                <Check size={12} weight="bold" />
                              </div>
                            )}
                          </div>
                          <span className="text-xs text-center">{color.name}</span>
                        </Label>
                      ))}
                    </RadioGroup>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader>
                    <CardTitle>Choose Text Color</CardTitle>
                    <CardDescription>Select the color for your text and name</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <RadioGroup 
                      value={selectedTextColor}
                      onValueChange={setSelectedTextColor}
                      className="grid grid-cols-5 gap-3"
                    >
                      {textColorOptions.map((color) => (
                        <Label
                          key={color.value}
                          htmlFor={`text-color-${color.value.substring(1)}`}
                          className="cursor-pointer flex flex-col items-center"
                        >
                          <RadioGroupItem 
                            value={color.value} 
                            id={`text-color-${color.value.substring(1)}`} 
                            className="sr-only" 
                          />
                          <div className="relative mb-2">
                            <div 
                              className="h-10 w-10 rounded-full shadow-sm transition-all"
                              style={{ 
                                backgroundColor: color.value,
                                border: color.value === "#FFFFFF" ? "1px solid #e2e8f0" : "none",
                              }}
                            />
                            {selectedTextColor === color.value && (
                              <div className="absolute -top-1 -right-1 h-5 w-5 rounded-full bg-primary text-primary-foreground flex items-center justify-center">
                                <Check size={12} weight="bold" />
                              </div>
                            )}
                          </div>
                          <span className="text-xs text-center">{color.name}</span>
                        </Label>
                      ))}
                    </RadioGroup>
                  </CardContent>
                </Card>

                <div className="flex justify-end">
                  <Button onClick={goToNextStep}>
                    Continue to Team Selection
                    <ArrowRight className="ml-2" weight="bold" />
                  </Button>
                </div>
              </TabsContent>

              {/* Step 2: Team Selection */}
              <TabsContent value="team" className="space-y-6 py-4">
                <Card>
                  <CardHeader>
                    <CardTitle>Choose Your Team</CardTitle>
                    <CardDescription>Select your sport, league, and team</CardDescription>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="space-y-2">
                      <Label htmlFor="sport">Sport</Label>
                      <Select 
                        value={selectedSport?.id || ""} 
                        onValueChange={(value) => {
                          const sport = sportsData.find(s => s.id === value);
                          setSelectedSport(sport || null);
                        }}
                      >
                        <SelectTrigger id="sport">
                          <SelectValue placeholder="Select Sport" />
                        </SelectTrigger>
                        <SelectContent>
                          {sportsData.map((sport) => (
                            <SelectItem key={sport.id} value={sport.id}>
                              {sport.name}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="league">League</Label>
                      <Select 
                        value={selectedLeague?.id || ""}
                        onValueChange={(value) => {
                          const league = selectedSport?.leagues.find(l => l.id === value);
                          setSelectedLeague(league || null);
                        }}
                        disabled={!selectedSport}
                      >
                        <SelectTrigger id="league">
                          <SelectValue placeholder="Select League" />
                        </SelectTrigger>
                        <SelectContent>
                          {selectedSport?.leagues.map((league) => (
                            <SelectItem key={league.id} value={league.id}>
                              {league.name}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="team">Team</Label>
                      <Select 
                        value={selectedTeam?.id || ""}
                        onValueChange={(value) => {
                          const team = selectedLeague?.teams.find(t => t.id === value);
                          setSelectedTeam(team || null);
                        }}
                        disabled={!selectedLeague}
                      >
                        <SelectTrigger id="team">
                          <SelectValue placeholder="Select Team" />
                        </SelectTrigger>
                        <SelectContent>
                          {selectedLeague?.teams.map((team) => (
                            <SelectItem key={team.id} value={team.id}>
                              {team.name}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                  </CardContent>
                </Card>

                <div className="flex justify-between">
                  <Button variant="outline" onClick={goToPreviousStep}>
                    Back to Product
                  </Button>
                  <Button onClick={goToNextStep}>
                    Continue to Personalization
                    <ArrowRight className="ml-2" weight="bold" />
                  </Button>
                </div>
              </TabsContent>

              {/* Step 3: Personalization */}
              <TabsContent value="personalize" className="space-y-6 py-4">
                <Card>
                  <CardHeader>
                    <CardTitle>Make It Yours</CardTitle>
                    <CardDescription>Add your name and an optional image</CardDescription>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="space-y-2">
                      <Label htmlFor="user-name">Your Name</Label>
                      <Input 
                        id="user-name" 
                        value={userName} 
                        onChange={(e) => setUserName(e.target.value)}
                        placeholder="Enter your name"
                        maxLength={15}
                      />
                    </div>
                    
                    <Separator className="my-4" />
                    
                    <div className="space-y-2">
                      <Label>Add Image (Optional)</Label>
                      <div className="flex flex-col sm:flex-row gap-3">
                        <div className="flex-1">
                          <Label 
                            htmlFor="image-upload" 
                            className="custom-file-upload flex justify-center items-center gap-2 w-full py-2 px-4 bg-primary text-primary-foreground rounded-md cursor-pointer"
                          >
                            <Upload size={20} />
                            <span>Upload Image</span>
                          </Label>
                          <Input 
                            id="image-upload" 
                            type="file" 
                            onChange={handleFileUpload}
                            accept="image/*" 
                            className="hidden"
                          />
                        </div>
                        <div className="flex-1">
                          <WebcamCapture onImageCapture={handleImageCapture} />
                        </div>
                      </div>
                      
                      {customImage && (
                        <div className="mt-4">
                          <p className="text-sm text-muted-foreground mb-2">Preview:</p>
                          <div className="w-24 h-24 rounded overflow-hidden border">
                            <img 
                              src={customImage} 
                              alt="Custom" 
                              className="w-full h-full object-cover"
                            />
                          </div>
                          <Button 
                            variant="outline" 
                            size="sm" 
                            className="mt-2"
                            onClick={() => setCustomImage(null)}
                          >
                            Remove
                          </Button>
                        </div>
                      )}
                    </div>
                  </CardContent>
                </Card>

                <div className="flex justify-between">
                  <Button variant="outline" onClick={goToPreviousStep}>
                    Back to Team Selection
                  </Button>
                  <Button>
                    Add to Cart
                    <CaretRight className="ml-2" weight="bold" />
                  </Button>
                </div>
              </TabsContent>
            </Tabs>
          </div>

          {/* Right column - Product visualization */}
          <div>
            <div className="sticky top-8">
              <Card className="bg-transparent border-dashed">
                <CardHeader className="bg-transparent">
                  <div className="flex justify-between items-center">
                    <div>
                      <CardTitle className="flex items-center gap-2">
                        {getProductIcon()}
                        {productType.charAt(0).toUpperCase() + productType.slice(1)} Preview
                      </CardTitle>
                      <CardDescription>
                        {selectedTeam ? selectedTeam.name : "Custom"} {productType} in {colorOptions.find(c => c.value === selectedColor)?.name} with {textColorOptions.find(c => c.value === selectedTextColor)?.name} text
                      </CardDescription>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="bg-transparent">
                  <div className="flex justify-center">
                    <ProductVisualization 
                      productType={productType}
                      color={selectedColor}
                      textColor={selectedTextColor}
                      teamName={selectedTeam?.name}
                      userName={userName}
                      customImage={customImage || undefined}
                      className="w-full max-w-[400px]"
                    />
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-6 px-6 border-t">
        <div className="max-w-7xl mx-auto text-center text-sm text-muted-foreground">
          © {new Date().getFullYear()} Zava Athletics. All rights reserved.
        </div>
      </footer>
    </div>
  );
}

export default App;