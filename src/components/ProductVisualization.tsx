import { useState, useEffect } from "react";
import { cn } from "@/lib/utils";
import { ProductType } from "@/lib/data";

interface ProductVisualizationProps {
  productType: ProductType;
  color: string;
  textColor?: string;
  teamName?: string;
  userName?: string;
  customImage?: string;
  className?: string;
}

export function ProductVisualization({
  productType,
  color,
  textColor = "#FFFFFF",
  teamName,
  userName,
  customImage,
  className
}: ProductVisualizationProps) {
  const [loading, setLoading] = useState(false);
  
  // Simulate loading when product changes
  useEffect(() => {
    setLoading(true);
    const timer = setTimeout(() => {
      setLoading(false);
    }, 500);
    
    return () => clearTimeout(timer);
  }, [productType, color, textColor]);

  // Get the stroke color based on the product color
  const getStrokeColor = () => {
    return color === "#FFFFFF" ? "#333333" : "#333333";
  };

  return (
    <div className={cn("product-visualization relative rounded-xl overflow-hidden", className)}>
      {loading ? (
        <div className="flex items-center justify-center w-full h-full min-h-[400px] animate-pulse">
          <span className="text-muted-foreground">Loading preview...</span>
        </div>
      ) : (
        <div className="product-preview relative w-full">
          {/* Product SVG Visualization - this would be replaced with actual product images */}
          <div className="product-base">
            <svg 
              viewBox="0 0 300 300" 
              className="w-full h-auto max-h-[500px]"
              aria-label={`${productType} visualization`}
              style={{ backgroundColor: "transparent" }}
            >
              {productType === "t-shirt" && (
                <g>
                  <path 
                    d="M75,50 L125,20 L175,20 L225,50 L225,250 L75,250 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M125,20 L175,20 L175,70 L125,70 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M75,50 L45,70 L60,100 L75,90 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M225,50 L255,70 L240,100 L225,90 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                </g>
              )}
              
              {productType === "hoodie" && (
                <g>
                  <path 
                    d="M75,70 L125,40 L175,40 L225,70 L225,250 L75,250 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M125,40 L175,40 L175,70 L125,70 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M75,70 L45,90 L60,120 L75,110 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M225,70 L255,90 L240,120 L225,110 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M125,40 L100,10 L150,0 L200,10 L175,40" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                </g>
              )}
              
              {productType === "cap" && (
                <g>
                  <path 
                    d="M100,130 C100,80 200,80 200,130 L220,130 L220,150 L80,150 L80,130 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M100,130 C100,100 200,100 200,130" 
                    fill="none" 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M150,130 L150,150" 
                    fill="none" 
                    stroke={getStrokeColor()} 
                    strokeDasharray="2,2"
                    strokeWidth="1"
                  />
                </g>
              )}
              
              {productType === "jacket" && (
                <g>
                  <path 
                    d="M75,60 L125,30 L175,30 L225,60 L225,250 L75,250 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M125,30 L175,30 L175,60 L150,80 L125,60 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M75,60 L45,80 L60,110 L75,100 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <path 
                    d="M225,60 L255,80 L240,110 L225,100 Z" 
                    fill={color} 
                    stroke={getStrokeColor()} 
                    strokeWidth="1"
                  />
                  <line 
                    x1="150" 
                    y1="80" 
                    x2="150" 
                    y2="250" 
                    stroke={getStrokeColor()} 
                    strokeDasharray="5,5"
                    strokeWidth="1"
                  />
                </g>
              )}
              
              {/* Team name positioning */}
              {teamName && (
                <text 
                  x="150" 
                  y={productType === "cap" ? "130" : "100"} 
                  fontSize="14" 
                  textAnchor="middle" 
                  fill={textColor}
                  fontFamily="Montserrat, sans-serif"
                  fontWeight="bold"
                >
                  {teamName}
                </text>
              )}
              
              {/* User name positioning */}
              {userName && productType !== "cap" && (
                <text 
                  x="150" 
                  y="220" 
                  fontSize="16" 
                  textAnchor="middle" 
                  fill={textColor}
                  fontFamily="Montserrat, sans-serif"
                  fontWeight="bold"
                >
                  {userName}
                </text>
              )}
              
              {/* Custom image positioning */}
              {customImage && (
                <image
                  x={productType === "cap" ? "125" : "115"}
                  y={productType === "cap" ? "105" : "120"}
                  width={productType === "cap" ? "50" : "70"}
                  height={productType === "cap" ? "30" : "70"}
                  href={customImage}
                  preserveAspectRatio="xMidYMid meet"
                />
              )}
            </svg>
          </div>
        </div>
      )}
    </div>
  );
}