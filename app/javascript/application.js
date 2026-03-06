// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap/dist/js/bootstrap"
import { setUpDriver } from "./driver";

window.bootstrap = bootstrap;

document.addEventListener("turbo:load", () => {
  console.log("turbo:load イベントが発火しました");
  
  // routes の index ページでのみ実行
  const routeIndexElement = document.getElementById("route-index");
  
  if (routeIndexElement) {
    console.log("routes の index ページです - driver.js を実行します");
    
    setTimeout(() => {
      setUpDriver();
    }, 100);
  } else {
    console.log("routes の index ページではないため、driver.js はスキップします");
  }
});
