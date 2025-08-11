const tab_nav = document.querySelector(".example-tabs__controls");
const tabs = document.querySelector(".example-tabs__tabs");
const tab_controls = tab_nav.querySelectorAll(':scope a');

const setActiveTab = (control) => {
  tab_nav.querySelector(':scope a[active]')?.removeAttribute('active')

  control.setAttribute('active', '')
}

const scrollTabIntoView = (href) => {
  const tab = document.querySelector(href);
  if(!tab) return;

  scrollIntoViewHorizontally(tabs, tab);
}

const determineActiveTabSection = () => {
  const i = tabs.scrollLeft / tabs.clientWidth
  const control = tab_controls[Math.floor(i)]

  if(!control) return;

  setActiveTab(control)

  window.history.replaceState({tab_target: control.getAttribute("href")}, null, control.href)
}

tab_controls.forEach(a => {
  a.addEventListener('click', e => {
    e.preventDefault();

    a.blur();

    tabs.childNodes.forEach(tab => {
      tab.classList?.remove("target")
    })
    document.querySelector(a.getAttribute("href")).classList.add("target")

    scrollTabIntoView(a.getAttribute("href"))
  })
})

tabs.addEventListener('scroll', () => {
  clearTimeout(tabs.scrollEndTimer)
  tabs.scrollEndTimer = setTimeout(
    determineActiveTabSection
  , 100)
})

window.addEventListener("load", () => {
  if (location.hash) {
    scrollTabIntoView(location.hash)
    determineActiveTabSection()
  } else {
    setActiveTab(tab_controls[0])
  }
})

const scrollIntoViewHorizontally = (
  container,
  child,
) => {
  const child_offsetRight = child.offsetLeft + child.offsetWidth;
  const container_scrollRight = container.scrollLeft + container.offsetWidth;

  if (container.scrollLeft > child.offsetLeft) {
    container.scrollLeft = child.offsetLeft;
  } else if (container_scrollRight < child_offsetRight) {
    container.scrollLeft += child_offsetRight - container_scrollRight;
  }
};
