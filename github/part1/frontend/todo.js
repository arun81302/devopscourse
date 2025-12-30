document.addEventListener('DOMContentLoaded',()=>{
  const form=document.getElementById('todo-form');
  const nameInput=document.getElementById('item-name');
  const descInput=document.getElementById('item-desc');
  const listEl=document.getElementById('todo-list');
  const STORAGE_KEY='todos.v1';

  function readTodos(){
    try{return JSON.parse(localStorage.getItem(STORAGE_KEY)||'[]')||[]}catch(e){return[]}
  }
  function writeTodos(todos){localStorage.setItem(STORAGE_KEY,JSON.stringify(todos))}

  function render(){
    const todos=readTodos();
    listEl.innerHTML='';
    if(todos.length===0){
      const p=document.createElement('p');
      p.textContent='No items yet.';
      listEl.appendChild(p);
      return
    }
    todos.forEach(t=>{
      const li=document.createElement('li');
      li.className='todo-item';

      const content=document.createElement('div');
      content.className='todo-content';

      const title=document.createElement('p');
      title.className='todo-title';
      title.textContent=t.name;

      const desc=document.createElement('p');
      desc.className='todo-desc';
      desc.textContent=t.description||'';

      content.appendChild(title);
      content.appendChild(desc);

      const actions=document.createElement('div');
      actions.className='todo-actions';

      const delBtn=document.createElement('button');
      delBtn.type='button';
      delBtn.textContent='Delete';
      delBtn.addEventListener('click',()=>{
        const remaining=readTodos().filter(x=>x.id!==t.id);
        writeTodos(remaining);
        render();
      });

      actions.appendChild(delBtn);

      li.appendChild(content);
      li.appendChild(actions);
      listEl.appendChild(li);
    })
  }

  form.addEventListener('submit',e=>{
    e.preventDefault();
    const name=nameInput.value.trim();
    const desc=descInput.value.trim();
    if(!name){
      nameInput.focus();
      return
    }
    const todos=readTodos();
    todos.unshift({id:Date.now().toString(),name,description:desc,created:Date.now()});
    writeTodos(todos);
    form.reset();
    render();
  });

  render();
});
