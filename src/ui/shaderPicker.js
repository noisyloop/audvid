// Shader picker modal + custom shader editor. Pure DOM: the shader list
// arrives as plain data via open()/refresh(), choices and custom-shader
// saves go back out through handler callbacks.

export function initShaderPicker(handlers) {
  const $ = (id) => document.getElementById(id);
  const els = {
    picker: $('picker'),
    close: $('pickerClose'),
    search: $('pickerSearch'),
    cats: $('pickerCats'),
    list: $('pickerList'),
    customAdd: $('customAdd'),
    modal: $('customModal'),
    customClose: $('customClose'),
    name: $('customName'),
    source: $('customSource'),
    file: $('customFile'),
    save: $('customSave'),
    err: $('customError'),
  };

  let data = { shaders: [], categories: ['all'], currentKey: null };
  let category = 'all';

  function renderCats() {
    els.cats.replaceChildren(
      ...data.categories.map((c) => {
        const b = document.createElement('button');
        b.textContent = c;
        b.classList.toggle('on', c === category);
        b.addEventListener('click', () => {
          category = c;
          renderCats();
          renderList();
        });
        return b;
      }),
    );
  }

  function renderList() {
    const q = els.search.value.trim().toLowerCase();
    const items = data.shaders.filter(
      (s) => (category === 'all' || s.category === category)
        && s.name.toLowerCase().includes(q),
    );
    els.list.replaceChildren(
      ...items.map((s) => {
        const b = document.createElement('button');
        b.classList.toggle('current', s.key === data.currentKey);
        const cat = document.createElement('span');
        cat.className = 'cat';
        cat.textContent = s.category;
        const name = document.createElement('span');
        name.textContent = s.name;
        b.append(cat, name);
        b.addEventListener('click', () => {
          els.picker.hidden = true;
          handlers.onSelect(s.key);
        });
        if (s.category === 'custom') {
          const del = document.createElement('span');
          del.className = 'del';
          del.textContent = '✕';
          del.addEventListener('click', (e) => {
            e.stopPropagation();
            handlers.onCustomDelete(s.key);
          });
          b.append(del);
        }
        return b;
      }),
    );
  }

  els.search.addEventListener('input', renderList);
  els.close.addEventListener('click', () => { els.picker.hidden = true; });

  // --- custom editor ---
  els.customAdd.addEventListener('click', () => {
    els.err.hidden = true;
    els.modal.hidden = false;
  });
  els.customClose.addEventListener('click', () => { els.modal.hidden = true; });
  els.file.addEventListener('change', async () => {
    const f = els.file.files[0];
    if (!f) return;
    els.source.value = await f.text();
    if (!els.name.value) els.name.value = f.name.replace(/\.\w+$/, '');
    els.file.value = '';
  });
  els.save.addEventListener('click', () => {
    const res = handlers.onCustomSave(els.name.value, els.source.value);
    if (res.ok) {
      // Saving also selects the new shader, so close the picker beneath too.
      els.modal.hidden = true;
      els.picker.hidden = true;
      els.name.value = '';
      els.source.value = '';
    } else {
      els.err.hidden = false;
      els.err.textContent = res.error;
    }
  });

  return {
    /** Show the picker. `d` = { shaders, categories, currentKey }. */
    open(d) {
      data = d;
      if (!data.categories.includes(category)) category = 'all';
      els.search.value = '';
      renderCats();
      renderList();
      els.picker.hidden = false;
    },
    /** Update the list in place (after a custom add/delete). */
    refresh(d) {
      data = d;
      if (!data.categories.includes(category)) category = 'all';
      renderCats();
      renderList();
    },
  };
}
