import { driver } from "driver.js";

export function setUpDriver() {
  const driverObj = driver({
    animate: true,
    showProgress: true,
    overlayOpacity: 0.75,
    showButtons: ["next", "previous", "close"],
    nextBtnText: '次へ',
    prevBtnText: '戻る',
    doneBtnText: '完了'
  });

  driverObj.setSteps([
    {
      element: "#step1",
      popover: { title: "step1", description: "説明1"}
    },
    {
      element: "#step2",
      popover: { title: "step1", description: "説明2"}
    },
    {
      element: "#step3",
      popover: { title: "step1", description: "説明3"}
    }
  ]);

  driverObj.drive();
}