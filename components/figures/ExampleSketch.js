import React, { useEffect, useState } from "react";
import { render } from "react-dom";
import * as Tone from "tone";
import dynamic from "next/dynamic";

const Sketch = dynamic(() => import("react-p5").then((mod) => mod.default), {
  ssr: false,
});

function ExampleSketch() {
  const [synth, setSynth] = useState(null);
  const [drawn, setDrawn] = useState(false);

  useEffect(() => {
    setSynth(new Tone.Synth().toDestination());
  }, []);

  const playSynth = () => {
    synth.triggerAttackRelease("C4", "60n");
  };

  const setup = (p5, canvasParentRef) => {
    const cnv = p5.createCanvas(500, 500).parent(canvasParentRef);
    cnv.mousePressed(playSynth);

    p5.frameRate(30);
  };

  const draw = (p5) => {
    p5.fill(234, 31, 81);
    p5.noStroke();
    p5.rect(50, 50, 250, 250);
    p5.fill(255);
    p5.textStyle(p5.BOLD);
    p5.textSize(140);
    p5.text("p5*", 60, 250);
  };

  return <Sketch setup={setup} draw={draw} />;
}

export default ExampleSketch;
