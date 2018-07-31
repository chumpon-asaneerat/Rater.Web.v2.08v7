<sidebars class="sidebar">
    <virtual if={(page.model.sidebar && page.model.sidebar.items && page.model.sidebar.items.length > 0)}>
        <ul>
            <virtual each={item in page.model.sidebar.items}>
                <li class="{(item.active === 'active' || item.active === 'true') ? 'active' : ''}">
                    <a href="{item.url}">
                        <virtual if={item.type === 'font'}>
                            <span class="fas fa-{item.src}"></span>
                            <label>{item.text}</label>
                        </virtual>
                        <virtual if={item.type === 'image'}>
                            <img src="{item.src}" />
                            <label>{item.text}</label>
                        </virtual>
                    </a>
                </li>
            </virtual>
        </ul>
    </virtual>
    <script>
        //-- local variables.
        let self = this;

        //-- setup service handlers.
        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);
    </script>
</sidebars>
